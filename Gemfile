source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 8.1.1'

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

gem 'dartsass-rails'
gem 'bootstrap', '~> 5.3'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use mysql2 gem for mysql connections
gem 'mysql2'
# or use a null adapter for scenarios that really require no database
gem 'activerecord-nulldb-adapter'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 2.0', group: :doc

# Use Puma as the app server
gem 'puma'

gem 'jira-ruby'
gem 'recaptcha', '~> 4.13'

gem 'nokogiri', '~> 1.18', '>= 1.18.9', force_ruby_platform: true

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.19.2', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-cul', require: false
  gem 'capistrano-passenger', '~> 0.2', require: false
  gem 'listen'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '>= 2.1'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.39.2'
  # For testing with chromedriver
  gem 'selenium-webdriver', '~> 4.16.0'
  gem 'rspec-rails', '~> 8.0.4'
  gem 'factory_bot_rails', ' ~> 4.0'
  gem 'simplecov',      require: false
  gem 'simplecov-lcov', require: false
  gem 'pry'
end
