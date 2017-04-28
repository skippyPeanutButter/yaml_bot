require 'yaml'
require 'yaml_bot/logging_bot'
require 'yaml_bot/validation_error'

module YamlBot
  class RulesBot
    attr_accessor :rules, :logger

    def initialize
      @rules = nil
      @missing_required_keys = false
      @missing_optional_keys = false
    end

    def validate_rules
      fail_if_rules_are_not_loaded
    end

    private

    def fail_if_rules_are_not_loaded
      return unless @rules.nil? && !@rules.instance_of?(Hash)
      msg = 'Cannot validate, rules file not loaded!'
      raise YamlBot::ValidationError, msg
    end
  end
end
