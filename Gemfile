source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'sass', '~> 3.7.4'
gem 'sprockets', '~> 3.7.2'
gem 'sprockets-rails', :require => 'sprockets/railtie'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use mysql2 gem for mysql connections
gem 'mysql2'
# or use a null adapter for scenarios that really require no database
gem 'activerecord-nulldb-adapter'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'bootstrap-sass', '~> 3.3.4'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '>= 0.12.1',  platforms: :ruby
gem 'libv8', '>= 3.16.14.7' # Min version for compiling on Mac OS 10.10

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 2.0', group: :doc

# Use Puma as the app server
gem 'puma'

gem 'jira-ruby'
gem 'recaptcha', '~> 4.13'

gem 'nokogiri', '~> 1.10.10'
gem 'mini_portile2', '~> 2.4.0'

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.5.0', require: false
  # Rails and Bundler integrations were moved out from Capistrano 3
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  # "idiomatic support for your preferred ruby version manager"
  gem 'capistrano-rvm', '~> 0.1', require: false
  # The `deploy:restart` hook for passenger applications is now in a separate gem
  # Just add it to your Gemfile and require it in your Capfile.
  gem 'capistrano-passenger', '~> 0.1', require: false

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.33'
  # For testing with chromedriver
  gem 'selenium-webdriver', '~> 3.142'
  # For automatically updating chromedriver
  gem 'webdrivers', '~> 4.0', require: false
  gem 'rspec-rails', '~> 4.0'
  gem 'factory_bot_rails', ' ~> 4.0'
  gem 'simplecov',      require: false
  gem 'simplecov-lcov', require: false
  gem 'pry'
end
