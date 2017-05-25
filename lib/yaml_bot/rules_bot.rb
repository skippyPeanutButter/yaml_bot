require 'yaml'
require 'yaml_bot/logging_bot'
require 'yaml_bot/validation_error'

module YamlBot
  class RulesBot
    attr_accessor :rules, :logger

    def initialize(rules)
      @rules = rules
    end

    def validate_rules

    end
  end
end
