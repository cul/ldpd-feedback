require 'jira'

class FeedbackSubmission
  
  include ActiveModel::Validations
  
  attr_reader :feedback_key, :form_config, :feedback_type
  attr_accessor :one_line_summary, :description, :name, :email, :submitted_from_page, :window_width, :window_height, :user_agent
  
  validates_presence_of :feedback_key, :one_line_summary, :description
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Invalid email format' }

  def initialize(feedback_key)
    @feedback_key = feedback_key
    @form_config = FEEDBACK_CONFIG[@feedback_key]
  end
  
  def feedback_type=(val)
    @feedback_type = val.to_i
  end
  
  def update(feedback_submission_params)
    feedback_submission_params.each do |key, value|
      self.send(key+'=', value)
    end
  end
  
  def submit
      return false unless self.valid?
      
      self.submit_to_jira if @form_config.has_key?('target') && @form_config['target'].has_key?('jira')
      self.submit_as_email if @form_config.has_key?('target') && @form_config['target'].has_key?('email')
      
      return @errors.blank?
  end

  def submit_to_jira
    jira_config = @form_config['target']['jira']
    
    begin
      client = JIRA::Client.new({
        :site => jira_config['jira_url'],
        :context_path => '/',
        :username => jira_config['username'],
        :password => jira_config['password'],
        :auth_type => :basic
      })
      
      issue = client.Issue.build
      issue.save({
        'fields' => {
          'issuetype' => { 'id' => self.feedback_type },
          'summary' => self.one_line_summary,
          'description' => self.description,
          'environment' => environment_message,
          'project' => { 'key' => jira_config['project'] }
        }
      })
    rescue
      @errors.add(:jira, 'Unable to connect to JIRA')
    end
  end

  def submit_as_email
    mail_to = @form_config['target']['email']['to']
    mail_from = 'do-not-reply@feedback.cul.columbia.edu'
    mail_subject = @form_config['target']['email']['subject']
    mail_message = 'A user has submitted feedback:' + "\n\n" +
      'Feedback Type: ' + @form_config['feedback_types'].key(self.feedback_type) + "\n" +
      'One Line Summary: ' + self.one_line_summary + "\n" +
      'Description: ' + self.description + "\n" +
      environment_message
      
    MyMailer.send_mail(mail_to, mail_from, mail_subject, mail_message).deliver
  end
  
  private
  
  def environment_message
    return (
      'Reporter Name: ' + (self.name || '-') + "\n" +
      'Reporter Email: ' + (self.email || '-') + "\n" +
      'Submitted From Page: ' + (self.submitted_from_page || '-') + "\n" +
      'Window Width: ' + (self.window_width || '-') + "\n" +
      'Window Height: ' + (self.window_height || '-') + "\n" +
      'User Agent : ' + (self.user_agent || '-') + "\n" +
      'Submitted On : ' + (Time.now.to_s) + "\n"
    )
  end
  
end
