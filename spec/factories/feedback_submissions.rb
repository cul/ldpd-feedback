# frozen_string_literal: true

FactoryBot.define do
  factory :feedback_submission do
    feedback_key { 'website' }
    feedback_type { 1 }
    one_line_summary { 'Great work!' }
    description { 'I mean, really great.' }

    trait :with_reporter_information do
      name { "Terry Reporter" }
      email { "t.reporter@example.org" }
    end

    trait :submitted_from_page do
      submitted_from_page { 'http://example.org/reference' }
    end

    trait :with_user_agent do
      user_agent { }
    end

    trait :with_invalid_feedback_type do
      feedback_type { 1001 }
    end

    trait :missing_description do
      description { nil }
    end

    trait :with_jira do
      feedback_key { 'with_jira' }
    end

    trait :with_email do
      feedback_key { 'with_email' }
    end
  end
end