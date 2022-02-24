require "rails_helper"

describe FeedbackSubmissionsHelper, type: :helper do
  let(:feedback_submission) { FactoryBot.build(:feedback_submission) }
  let(:error_field) { nil }
  let(:message) { helper.render_error_messages_if_present(feedback_submission, error_field) }
  before { feedback_submission.valid? }

  describe '#render_error_messages_if_present' do
    context 'no error key is present' do
      it 'returns blank output' do
        expect(message).to be_blank
      end
    end

    context 'errors are present' do
      let(:feedback_submission) { FactoryBot.build(:feedback_submission, :missing_description) }

      context 'error key is present' do
        let(:error_field) { :description }
        let(:fragment) { Nokogiri::HTML(message) }
        it 'returns output including an error message' do
          expect(fragment.at_css(".alert > ul > li").text).to match("A description is required")
        end
      end

      context 'error key is absent' do
        let(:error_field) { :name }
        it 'returns blank output' do
          expect(message).to be_blank
        end
      end
    end
  end
end
