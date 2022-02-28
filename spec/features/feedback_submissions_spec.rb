require "rails_helper"

describe "FeedbackSubmissions", type: :feature do
  let(:template_submission) { FactoryBot.build(:feedback_submission) }
  describe 'root' do
    before do
      visit '/'
    end
    it 'displays a basic application title' do
      expect(page).to have_css("h1", text: 'CUL Feedback')
    end
  end
  describe 'feedback form' do
    before do
      visit new_feedback_submission_path(id: template_submission.feedback_key)
    end
    it 'displays configured feedback title' do
      expect(page).to have_css("h1", text: 'Website Suggestions & Feedback')
    end
    it 'routes to success after successful submission' do
      select 'Report an issue', from: 'Feedback Type'
      fill_in 'Summary', with: template_submission.one_line_summary
      fill_in 'Description', with: template_submission.description
      click_on('Submit')
      expect(page).to have_css("h1", text: 'Thank you')      
    end
    it 'displays error messages when submission is invalid' do
      select 'Report an issue', from: 'Feedback Type'
      fill_in 'Summary', with: template_submission.one_line_summary
      click_on('Submit')
      expect(page).to have_css(".alert > ul > li", text: "A description is required")
    end
  end
end
