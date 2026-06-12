# frozen_string_literal: true

require Rails.root.join('config/environments/deployed.rb')

Rails.application.configure do
  # TODO: Enable when ready
  # config.action_mailer.default_url_options = { host: 'diglib-rails-prod1.cul.columbia.edu' }
end
