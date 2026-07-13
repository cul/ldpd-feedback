require 'rails_helper'

describe 'hCaptcha verification', type: :request do
  let(:feedback_submission) { FactoryBot.build(:feedback_submission) }
  let(:valid_params) do
    {
      feedback_type: feedback_submission.feedback_type,
      one_line_summary: feedback_submission.one_line_summary,
      description: feedback_submission.description,
      'h-captcha-response' => 'test-token'
    }
  end

  def stub_siteverify(success:, error_codes: [])
    body = { 'success' => success, 'error-codes' => error_codes }.to_json
    allow(Net::HTTP).to receive(:post_form).and_return(double(body: body))
  end

  context 'when hCaptcha verification succeeds' do
    before { stub_siteverify(success: true) }

    it 'allows the submission through and redirects to success' do
      post "/feedback_submission/#{feedback_submission.feedback_key}", params: valid_params
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(success_feedback_submission_path(feedback_submission.feedback_key))
    end
  end

  context 'when hCaptcha verification fails' do
    before { stub_siteverify(success: false, error_codes: ['invalid-input-response']) }

    it 'blocks submission and re-renders the form with an error' do
      post "/feedback_submission/#{feedback_submission.feedback_key}", params: valid_params
      expect(response.body).to include('Captcha verification failed')
    end
  end

  context 'when the hCaptcha token is missing' do
    it 're-renders the form with a required error' do
      post "/feedback_submission/#{feedback_submission.feedback_key}", params: valid_params.except('h-captcha-response')
      expect(response.body).to include('Captcha verification is required')
    end
  end
end
