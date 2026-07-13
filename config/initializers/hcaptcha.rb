# frozen_string_literal: true

module Hcaptcha
  # Test keys provided by hCaptcha for testing purposes. See https://docs.hcaptcha.com/#test-keys
  TEST_SITE_KEY = '10000000-ffff-ffff-ffff-000000000001'
  TEST_SECRET_KEY = '0x0000000000000000000000000000000000000000'

  SECRET_KEY = Rails.application.credentials.dig(:hcaptcha, :secret_key) ||
               (Rails.env.test? ? TEST_SECRET_KEY : nil)
  SITE_KEY = Rails.application.credentials.dig(:hcaptcha, :site_key) ||
             (Rails.env.test? ? TEST_SITE_KEY : nil)

  unless Rails.env.test?
    raise 'hCaptcha secret_key is not set in credentials' if SECRET_KEY.blank?
    raise 'hCaptcha site_key is not set in credentials' if SITE_KEY.blank?
  end
end
