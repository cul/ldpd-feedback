class FeedbackSubmissionsController < ApplicationController
  before_action :set_feedback_submission, only: [:new, :create, :success]
  after_action :allow_iframe, only: [:new, :create, :success] # Allow these actions to be loaded in an iframe

  # GET /feedback_submissions
  # GET /feedback_submissions.json
  def index
  end

  # GET /feedback_submissions/new
  def new
  end

  # POST /feedback_submissions
  # POST /feedback_submissions
  def create
    @feedback_submission.update(feedback_submission_params.merge('user_agent' => request.user_agent))

    respond_to do |format|
      if verify_recaptcha(model: @feedback_submission) && @feedback_submission.submit
        format.html { redirect_to success_feedback_submission_path(@feedback_submission.feedback_key), notice: 'Feedback submission was successfully created.' }
        format.json { render json: {success: true} }
      else
        format.html { render :new } # Errors will be displayed in the view
        format.json { render json: @feedback_submission.errors.to_json, status: :unprocessable_entity }
      end
    end
  end

  def success
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_feedback_submission
    raise ActionController::RoutingError.new('Not Found') unless FEEDBACK_CONFIG.has_key?(params[:id])
    @feedback_submission = FeedbackSubmission.new(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feedback_submission_params
    params.permit(:feedback_type, :one_line_summary, :description, :name, :email, :submitted_from_page, :window_width, :window_height)
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end
