FEEDBACK_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/feedback_config.yml", aliases: true)[Rails.env]
