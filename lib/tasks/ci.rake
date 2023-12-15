
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
    puts "[Warning] Exception creating rspec rake tasks.  This message can be ignored in environments that intentionally do not pull in the RSpec gem (i.e. production)."
    puts e
  end
  desc "CI build"
  task ci: [:'feedback:config_files', :environment, :'feedback:rspec']
    # Note: Don't include Rails environment for this task, since enviroment includes a check for the presence of database.yml
  task :config_files do
    # yml templates
    Dir.glob(File.join(Rails.root, "config/templates/*.template.yml")).each do |template_yml_path|
      target_yml_path = File.join(Rails.root, 'config', File.basename(template_yml_path).sub(".template.yml", ".yml"))
      FileUtils.touch(target_yml_path) # Create if it doesn't exist
      target_yml = YAML.load_file(target_yml_path) || YAML.load_file(template_yml_path, aliases: true)
      File.open(target_yml_path, 'w') {|f| f.write target_yml.to_yaml }
    end
    Dir.glob(File.join(Rails.root, "config/templates/*.template.yml.erb")).each do |template_yml_path|
      target_yml_path = File.join(Rails.root, 'config', File.basename(template_yml_path).sub(".template.yml.erb", ".yml"))
      FileUtils.touch(target_yml_path) # Create if it doesn't exist
      target_yml = YAML.load_file(target_yml_path) || YAML.load(ERB.new(File.read(template_yml_path)).result(binding), aliases: true)
      File.open(target_yml_path, 'w') {|f| f.write target_yml.to_yaml }
    end
  end
end
