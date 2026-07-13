# frozen_string_literal: true

require Rails.root.join('config/environments/deployed.rb')
require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Verbose logging on the dev server.
  config.log_level = :debug

  config.action_mailer.default_url_options = { host: 'feedback-dev.library.columbia.edu' }
end
