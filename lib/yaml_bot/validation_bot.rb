require 'yaml'
require 'yaml_bot/rules_bot'
require 'yaml_bot/validation_error'

module YamlBot
  class ValidationBot
    attr_accessor :rules, :yaml_file
    @@violations = 0

    def self.violation
      @@violations += 1
    end

    def self.get_violations
      @@violations
    end

    def initialize

    end

    def scan
      if rules.nil? || yaml_file.nil?
        msg = "Rules file, or Yaml file is not set\n"
        raise YamlBot::ValidationError.new(msg)
      end


    end
  end
end
