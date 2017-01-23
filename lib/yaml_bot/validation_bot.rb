require 'yaml'
require 'yaml_bot/logging_bot'
require 'yaml_bot/rules_bot'
require 'yaml_bot/validation_error'

module YamlBot
  class ValidationBot
    attr_accessor :rules, :yaml_file, :violations, :logger

    def initialize
      self.violations = 0
    end

    def scan
      defaults = rules['defaults']
      rules['rules'].each do |key|
        key = KeyBot.new(key, yaml_file, defaults)
        self.violations += key.validate
      end
    end
  end
end
