# frozen_string_literal: true

require 'jira-ruby'

class FeedbackSubmission
  include ActiveModel::Validations

  attr_reader :feedback_key, :form_config, :feedback_type
  attr_accessor :one_line_summary, :description, :name, :email, :submitted_from_page, :window_width, :window_height,
                :user_agent

  validate :valid_feedback_type?

  validates :feedback_key, presence: { message: 'A feedback key must be specified in the URL.' }
  validates :feedback_type, presence: { message: 'A feedback type is required.' }
  validates :feedback_type, numericality: { message: 'Feedback type value must be numeric.' }

  validates :one_line_summary, presence: { message: 'A one line summary is required.' }
  validates :one_line_summary, length: { maximum: 150, message: 'Too many characters (150 max).' }

  validates :description, presence: { message: 'A description is required.' }
  validates :description, length: { maximum: 2000, message: 'Too many characters (2000 max).' }

  validates :name, length: { maximum: 100, message: 'Too many characters (100 max).' }

  validates :email, allow_blank: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Invalid email format.' }
  validates :email, length: { maximum: 100, message: 'Too many characters (100 max).' }

  validates :user_agent, length: { maximum: 300, message: 'User Agent is too long.' } # A user agent shouldn't ever be this long, but we don't want people messing with headers and sending crazy long user agent strings.

  validates :submitted_from_page, allow_blank: true, length: { maximum: 2000, message: 'Submission URL is too long.' } # A submission URL shouldn't ever be this long, but we need some limit for pages with complex query string params.
  validates :window_width, :window_height, allow_blank: true, numericality: { message: 'Window width/height must be numeric.' } # :window_height

  def initialize(feedback_key = nil)
    self.feedback_key = feedback_key
  end

  def feedback_key=(feedback_key)
    @feedback_key = feedback_key
    @form_config = FEEDBACK_CONFIG[@feedback_key] || {}
  end

  def feedback_type=(val)
    @feedback_type = val.to_i
  end

  def valid_feedback_type?
    return if @form_config['feedback_types'].value?(self.feedback_type)

    errors.add(:feedback_type, 'Invalid feedback type.')
  end

  def update(feedback_submission_params)
    feedback_submission_params.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def submit
    return false unless self.valid?

    self.submit_to_jira if @form_config.key?('target') && @form_config['target'].key?('jira')
    self.submit_as_email if @form_config.key?('target') && @form_config['target'].key?('email')

    @errors.blank?
  end

  def build_jira_issue(jira_config)
    JIRA::Client.new({
      site: jira_config['jira_url'],
      context_path: '/',
      username: jira_config['username'],
      password: jira_config['password'],
      auth_type: :basic
    }).Issue.build
  end

  def submit_to_jira
    jira_config = @form_config['target']['jira']

    begin
      issue = build_jira_issue(jira_config)

      result = issue.save({
        'fields' => {
          'issuetype' => { 'id' => self.feedback_type },
          'summary' => self.one_line_summary,
          'description' => self.description,
          'environment' => environment_message,
          'project' => { 'key' => jira_config['project'] }
        }
      })

      unless result
        @errors.add(:jira, 'An unexpected error occurred while submitting your feedback.')
        Rails.logger.error("One or more errors encountered during issue submission for project #{jira_config['project']}: #{issue.errors.inspect}")
      end
    rescue Exception => e
      @errors.add(:jira, 'Unable to connect to the ticket submission system.')
      Rails.logger.error("Unable to connect to JIRA: #{e} -> #{e.message}\n\n#{e.backtrace.join("\n")}")
    end
  end

  def submit_as_email
    mail_to = @form_config['target']['email']['to']
    mail_from = 'do-not-reply@library.columbia.edu'
    mail_subject = @form_config['target']['email']['subject']
    mail_message = 'A user has submitted feedback:' + "\n\n" \
                   'Feedback Type: ' + @form_config['feedback_types'].key(self.feedback_type) + "\n\n" \
                   'One Line Summary: ' + self.one_line_summary + "\n\n" \
                   'Description: ' + self.description + "\n\n" +
                   environment_message

    ApplicationMailer.send_mail(mail_to, mail_from, mail_subject, mail_message).deliver
  end

  private

  def environment_message
    (
      'Reporter Name: ' + (self.name.presence || '-') + "\n\n" \
      'Reporter Email: ' + (self.email.presence || '-') + "\n\n" \
      'Submitted From Page: ' + (self.submitted_from_page.presence || '-') + "\n\n" \
      'Window Width: ' + (self.window_width.presence || '-') + "\n\n" \
      'Window Height: ' + (self.window_height.presence || '-') + "\n\n" \
      'User Agent : ' + (self.user_agent.presence || '-') + "\n\n" \
      'Submitted On : ' + Time.zone.now.to_s + "\n"
    )
  end
end
