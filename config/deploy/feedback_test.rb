set :rails_env, "feedback_test"
set :application, "feedback_test"
set :domain,      "ldpd-nginx-test1.cul.columbia.edu"
set :deploy_to,   "/opt/passenger/ldpd/#{application}/"
set :user, "ldpdserv"
set :scm_passphrase, "Current user can full owner domains."

role :app, domain
role :web, domain
role :db,  domain, :primary => true
