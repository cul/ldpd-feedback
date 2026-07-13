# frozen_string_literal: true

# default requires
require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# include common CUL tasks
require 'capistrano/cul'
# additional optional modules used by clio
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'
