set :rails_env, "feedback_dev"
set :application, "feedback_dev"
set :domain,      "all-nginx-dev1.cul.columbia.edu"
set :deploy_to,   "/opt/passenger/ldpd/#{application}/"
set :user, "ldpdserv"
set :scm_passphrase, "Current user can full owner domains."
#set :bundle_cmd, "/home/ldpdserv/.rvm/gems/ruby-2.2.3/bin/bundle"
#set :rvm_bin_path, "/home/ldpdserv/.rvm/gems/ruby-2.2.3/bin/"
#set :bundle_dir, "/home/ldpdserv/.rvm/gems/ruby-2.2.3"

role :app, domain
role :web, domain
role :db,  domain, :primary => true
