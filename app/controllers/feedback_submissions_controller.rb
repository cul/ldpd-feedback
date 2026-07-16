# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class FeedbackSubmissionsController < ApplicationController
  before_action :set_feedback_submission, only: [:new, :create, :success]
  after_action :allow_iframe, only: [:new, :create, :success] # Allow these actions to be loaded in an iframe

  HCAPTCHA_VERIFY_URL = 'https://api.hcaptcha.com/siteverify'

  # GET /feedback_submissions
  # GET /feedback_submissions.json
  def index; end

  # GET /feedback_submissions/new
  def new; end

  # POST /feedback_submissions
  # POST /feedback_submissions
  def create
    @feedback_submission.update(feedback_submission_params.merge('user_agent' => request.user_agent))

    respond_to do |format|
      if verify_hcaptcha && @feedback_submission.submit
        format.html do
          redirect_to success_feedback_submission_path(@feedback_submission.feedback_key),
                      notice: 'Feedback submission was successfully created.'
        end
        format.json { render json: { success: true } }
      else
        format.html { render :new } # Errors will be displayed in the view
        format.json { render json: @feedback_submission.errors.to_json, status: :unprocessable_entity }
      end
    end
  end

  def success; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_feedback_submission
    raise ActionController::RoutingError, 'Not Found' unless FEEDBACK_CONFIG.key?(params[:id])

    @feedback_submission = FeedbackSubmission.new(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feedback_submission_params
    params.permit(:feedback_type, :one_line_summary, :description, :name, :email, :submitted_from_page, :window_width,
                  :window_height)
  end

  def verify_hcaptcha
    token = params['h-captcha-response']

    if token.blank?
      @feedback_submission.errors.add(:base, 'Captcha verification is required.')
      return false
    end

    # Sends a POST request with application/x-www-form-urlencoded Content-Type expected by hCaptcha
    response = Net::HTTP.post_form(
      URI(HCAPTCHA_VERIFY_URL),
      'secret' => Hcaptcha::SECRET_KEY,
      'response' => token,
      'remoteip' => request.remote_ip,
      'sitekey' => Hcaptcha::SITE_KEY
    )

    result = JSON.parse(response.body)

    unless result['success']
      Rails.logger.error("hCaptcha verification failed: #{result['error-codes']}")
      @feedback_submission.errors.add(:base, 'Captcha verification failed. Please try again.')
    end

    result['success']
  rescue StandardError => e
    Rails.logger.error("hCaptcha verification error: #{e.message}")
    @feedback_submission.errors.add(:base, 'Unable to verify captcha. Please try again.')
    false
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
