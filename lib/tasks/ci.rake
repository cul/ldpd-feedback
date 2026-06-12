# frozen_string_literal: true

namespace :feedback do
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:rspec) do |spec|
      spec.pattern = FileList['spec/**/*_spec.rb']
      spec.pattern += FileList['spec/*_spec.rb']
      spec.rspec_opts = ['--backtrace'] if ENV['CI']
    end

    RSpec::Core::RakeTask.new(:rcov) do |spec|
      spec.pattern = FileList['spec/**/*_spec.rb']
      spec.pattern += FileList['spec/*_spec.rb']
      spec.rcov = true
    end
  rescue LoadError => e
    puts '[Warning] Exception creating rspec rake tasks.  This message can be ignored in environments that intentionally do not pull in the RSpec gem (i.e. production).'
    puts e
  end

  desc 'CI build'
  task ci: [:'feedback:config_files', :'feedback:credentials_files', :environment, :'feedback:rspec']
  # NOTE: Don't include Rails environment for this task, since enviroment includes a check for the presence of database.yml

  task :config_files do
    # yml templates
    Dir.glob(Rails.root.join('config/templates/*.template.yml').to_s).each do |template_yml_path|
      target_yml_path = Rails.root.join('config', File.basename(template_yml_path).sub('.template.yml', '.yml')).to_s
      FileUtils.touch(target_yml_path) # Create if it doesn't exist
      target_yml = YAML.load_file(target_yml_path, aliases: true) || YAML.load_file(template_yml_path, aliases: true)
      File.open(target_yml_path, 'w') { |f| f.write target_yml.to_yaml }
    end

    Dir.glob(Rails.root.join('config/templates/*.template.yml.erb').to_s).each do |template_yml_path|
      next if File.basename(template_yml_path) == 'credentials.template.yml.erb'

      target_yml_path = Rails.root.join('config',
                                        File.basename(template_yml_path).sub('.template.yml.erb', '.yml')).to_s
      FileUtils.touch(target_yml_path) # Create if it doesn't exist
      target_yml = YAML.load_file(target_yml_path,
                                  aliases: true) || YAML.load(ERB.new(File.read(template_yml_path)).result(binding),
                                                              aliases: true)
      File.open(target_yml_path, 'w') { |f| f.write target_yml.to_yaml }
    end
  end

  desc 'Generate encrypted credentials from a template'
  task :credentials_files do
    require 'active_support/encrypted_configuration'

    rails_env = ENV.fetch('RAILS_ENV', 'test')
    template_path = Rails.root.join('config/templates/credentials.template.yml.erb')
    enc_path = Rails.root.join('config/credentials', "#{rails_env}.yml.enc")
    key_path = Rails.root.join('config/credentials', "#{rails_env}.key")

    FileUtils.mkdir_p(enc_path.dirname)
    key = ActiveSupport::EncryptedFile.generate_key
    File.write(key_path, key)
    ENV['RAILS_MASTER_KEY'] = key

    File.delete(enc_path) if File.exist?(enc_path)

    ActiveSupport::EncryptedConfiguration.new(
      config_path: enc_path,
      key_path: key_path,
      env_key: 'RAILS_MASTER_KEY',
      raise_if_missing_key: true
    ).write(ERB.new(File.read(template_path)).result(binding))

    puts "[credentials_files] enc exists? #{File.exist?(enc_path)}"
  end
end
