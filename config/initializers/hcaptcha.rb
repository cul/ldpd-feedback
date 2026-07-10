# frozen_string_literal: true

module Hcaptcha
  SECRET_KEY = Rails.application.credentials.dig(:hcaptcha, :secret_key)
  SITE_KEY = Rails.application.credentials.dig(:hcaptcha, :site_key)

  puts "HCAPTCHA_SECRET_KEY: #{SECRET_KEY}"
  puts "HCAPTCHA_SITE_KEY: #{SITE_KEY}"
  raise 'hCaptcha secret_key is not set in credentials' if SECRET_KEY.blank?
  raise 'hCaptcha site_key is not set in credentials' if SITE_KEY.blank?
end
