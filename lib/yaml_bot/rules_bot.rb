require 'yaml'
require 'yaml_bot/logging'
require 'yaml_bot/validation_error'

module YamlBot
  class RulesBot
    attr_accessor :rules

    def initialize
      @rules = nil
      @missing_required_keys = false
      @missing_optional_keys = false
    end

    def validate_rules
      fail_if_rules_are_not_loaded
      validate_root_keys
      check_top_level_keys
      YamlBot::Logging.info 'Rules file validated.'
    end

    private

    def check_top_level_keys
      [:required, :optional].each do |key_type|
        missing = @missing_optional_keys
        missing = @missing_required_keys if key_type == :required

        next if missing
        @rules[:root_keys][key_type].each do |key|
          name = key.keys.first
          validate_accepted_types(key[name]) unless
                                             key[name][:accepted_types].nil?
          validate_keys(key[name][:subkeys]) unless key[name][:subkeys].nil?
        end
      end
    end

    def validate_root_keys
      check_existance_of_required_keys
      check_existance_of_optional_keys
      fail_validation_if_missing_required_and_optional_keys
    end

    def check_existance_of_required_keys
      if !@rules[:root_keys].instance_of?(Hash) ||
         @rules[:root_keys][:required].nil?
        @missing_required_keys = true
        YamlBot::Logging.info 'No required keys specified.'
      end
    end

    def check_existance_of_optional_keys
      if !@rules[:root_keys].instance_of?(Hash) ||
         @rules[:root_keys][:optional].nil?
        @missing_optional_keys = true
        YamlBot::Logging.info 'No optional keys specified.'
      end
    end

    def fail_validation_if_missing_required_and_optional_keys
      return unless @missing_required_keys && @missing_optional_keys
      msg = "Missing both required and optional root keys.\n"
      msg += "Rules file must include at least one of those keys.\n"
      raise YamlBot::ValidationError, msg
    end

    def validate_keys(rules)
      [:required, :optional].each do |key_type|
        next if rules[key_type].nil?
        rules[key_type].each do |key|
          validate_accepted_types(key) unless key[:accepted_types].nil?
          validate_keys(key[:subkeys]) unless key[:subkeys].nil?
        end
      end
    end

    def fail_if_rules_are_not_loaded
      return unless @rules.nil? && @rules.instance_of?(Hash)
      msg = 'Cannot validate, rules file not loaded!'
      raise YamlBot::ValidationError, msg
    end

    def validate_accepted_types(key_hash)
      file_name = File.dirname(File.realpath(__FILE__)) +
                  '/resources/valid_accepted_types.yml'
      allowed_values = YAML.load(File.open(file_name))

      key_hash[:accepted_types].each do |type|
        next if allowed_values.include?(type)
        msg = "Invalid value for key: #{type}\n"
        msg += "Valid key values are #{allowed_values}"
        raise YamlBot::ValidationError, msg
      end
    end
  end
end
