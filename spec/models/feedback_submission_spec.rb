require "rails_helper"

describe FeedbackSubmission, type: :model do
  let(:traits) { [] }
  let(:feedback_submission) { FactoryBot.build(:feedback_submission, *traits) }
  describe '#submit' do
    context 'no targets' do
      context 'no errors' do
        it 'does nothing and returns true' do
          expect(feedback_submission).not_to receive(:submit_to_jira)
          expect(feedback_submission).not_to receive(:submit_as_email)
          expect(feedback_submission.submit).to be true
        end
      end
      context 'with errors' do
        let(:traits) { [:missing_description] }
        it 'does nothing and returns false' do
          expect(feedback_submission).not_to receive(:submit_to_jira)
          expect(feedback_submission).not_to receive(:submit_as_email)
          expect(feedback_submission.submit).to be false
        end
      end
    end
    context 'jira target' do
      let(:traits) { [:with_jira] }
      context 'no errors' do
        it 'does nothing and returns true' do
          expect(feedback_submission).to receive(:submit_to_jira)
          expect(feedback_submission).not_to receive(:submit_as_email)
          expect(feedback_submission.submit).to be true
        end
      end
      context 'with errors' do
        let(:traits) { [:missing_description, :with_jira] }
        it 'does nothing and returns false' do
          expect(feedback_submission).not_to receive(:submit_to_jira)
          expect(feedback_submission).not_to receive(:submit_as_email)
          expect(feedback_submission.submit).to be false
        end
      end
    end
    context 'email target' do
      let(:traits) { [:with_email] }
      context 'no errors' do
        it 'does nothing and returns true' do
          expect(feedback_submission).not_to receive(:submit_to_jira)
          expect(feedback_submission).to receive(:submit_as_email)
          expect(feedback_submission.submit).to be true
        end
      end
      context 'with errors' do
        let(:traits) { [:missing_description, :with_email] }
        it 'does nothing and returns false' do
          expect(feedback_submission).not_to receive(:submit_to_jira)
          expect(feedback_submission).not_to receive(:submit_as_email)
          expect(feedback_submission.submit).to be false
        end
      end
    end
  end
end
