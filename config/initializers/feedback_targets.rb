# frozen_string_literal: true

FEEDBACK_CONFIG = YAML.load_file(Rails.root.join('config/feedback_config.yml').to_s, aliases: true)[Rails.env]
