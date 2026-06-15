# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

# Shared configuration for deployed environments (feedback_dev, feedback_test and feedback_prod).
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Default to errors; feedback_dev overrides to :debug
  config.log_level = :error

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.sendmail_settings = {
    location: '/usr/sbin/sendmail',
    arguments: ['-i', '-t']
  }

  # Fall back to the default locale when a translation is missing.
  config.i18n.fallbacks = true

  # Use the default logging formatter so PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
end
