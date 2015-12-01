# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'feedback'
set :repo_url, 'git@github.com:cul/feedback.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/feedback_config.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('log')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :default_env, { path: "/opt/ruby/ruby-2.2.2/bin/ruby:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# This is for 'passenger-config restart-app', which
# isn't working anyway.
# # Capistrano can't find passenger:
# #   ERROR: Phusion Passenger doesn't seem to be running
# # So tell it where we it's installed:
# #   https://github.com/capistrano/passenger/blob/master/README.md
# set :passenger_environment_variables, { :path => '$PATH:/opt/nginx/passenger/passenger-5.0.7/bin' }

# can't get "passenger-config restart-app" working
set :passenger_restart_with_touch, true


namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end







#set :default_stage, "feedback_dev"
#set :stages, %w(feedback_dev feedback_test feedback_prod)
#
#require 'capistrano/ext/multistage'
#require 'bundler/capistrano'
#require 'date'
#
#default_run_options[:pty] = true
#
#set :application, "feedback"
#set :branch do
#  default_tag = `git tag`.split("\n").last
#
#  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
#  tag = default_tag if tag.empty?
#  tag
#end
#
#set :scm, :git
#set :git_enable_submodules, 1
#set :deploy_via, :remote_cache
#set :repository,  "git@github.com:cul/feedback.git"
#set :use_sudo, false
#
## Note: The line below is meaningless. It's just a workaround for Rails 4.0 because
## in 4.0, initializers and the database configuration are always loaded before
## precompiling assets.  This doesn't work for us because we add the database symlink
## at the end.  Maybe later, we'll see if we can just set up the database symlink earlier
## in the deploy process, but hopefully this will work as a fix for now.
## See: https://iprog.com/posting/2013/07/errors-when-precompiling-assets-in-rails-4-0
#set :asset_env, "RAILS_GROUPS=assets DATABASE_URL=mysql2://user:pass@127.0.0.1/dbname"
#
#namespace :deploy do
#  desc "Add tag based on current version"
#  task :auto_tag, :roles => :app do
#    current_version = 'v' +
#                      IO.read("VERSION").strip +
#                      "/" +
#                      DateTime.now.strftime("%Y%m%d")
#    tag = Capistrano::CLI.ui.ask "Tag to add: [#{current_version}] "
#    tag = current_version if tag.empty?
#
#    system("git tag -a #{tag} -m 'auto-tagged' && git push origin --tags")
#  end
#
#  desc "Restart Application"
#  task :restart, :roles => :app do
#    run "mkdir -p #{current_path}/tmp/cookies"
#    run "touch #{current_path}/tmp/restart.txt"
#  end
#
#  task :symlink_shared do
#    run "ln -nfs #{deploy_to}shared/database.yml #{release_path}/config/database.yml"
#    run "ln -nfs #{deploy_to}shared/secrets.yml #{release_path}/config/secrets.yml"
#    run "ln -nfs #{deploy_to}shared/feedback_config.yml #{release_path}/config/feedback_config.yml"
#
#    run "mkdir -p #{release_path}/db"
#    run "ln -nfs #{deploy_to}shared/#{rails_env}.sqlite3 #{release_path}/db/#{rails_env}.sqlite3"
#  end
#
#
#  desc "Compile assets"
#  task :assets do
#    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:clean assets:precompile"
#  end
#
#end
#
#
#
#after 'deploy:update_code', 'deploy:symlink_shared'
#before "deploy:create_symlink", "deploy:assets"
