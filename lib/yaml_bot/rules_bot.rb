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
      check_rules_are_loaded
      validate_root_keys
      unless @missing_required_keys
        @rules[:root_keys][:required].each do |key|
          name = key.keys.first
          unless key[name][:accepted_types].nil?
            validate_accepted_types(key[name])
          end

          unless key[name][:subkeys].nil?
            validate_keys(key[name][:subkeys])
          end
        end
      end

      unless @missing_optional_keys
        @rules[:root_keys][:optional].each do |key|
          name = key.keys.first
          unless key[name][:accepted_types].nil?
            validate_accepted_types(key[name])
          end

          unless key[name][:subkeys].nil?
            validate_keys(key[name][:subkeys])
          end
        end
      end

      YamlBot::Logging.info 'Rules file validated.'
    end

    def validate_root_keys
      if !@rules[:root_keys].instance_of?(Hash) ||
          @rules[:root_keys][:required].nil?
        @missing_required_keys = true
        YamlBot::Logging.info 'No required keys specified.'
      end
      if !@rules[:root_keys].instance_of?(Hash) ||
          @rules[:root_keys][:optional].nil?
        @missing_optional_keys = true
        YamlBot::Logging.info 'No optional keys specified.'
      end
      if @missing_required_keys && @missing_optional_keys
        msg = "Missing both required and optional root keys.\n"
        msg += "Rules file must include at least one of those keys.\n"
        raise YamlBot::ValidationError.new(msg)
      end
    end

    def validate_keys(rules)
      unless rules[:required].nil?
        rules[:required].each do |key|
          unless key[:accepted_types].nil?
            validate_accepted_types(key)
          end

          unless key[:subkeys].nil?
            validate_keys(key[:subkeys])
          end
        end
      end

      unless rules[:optional].nil?
        rules[:optional].each do |key|
          unless key[:accepted_types].nil?
            validate_accepted_types(key)
          end

          unless key[:subkeys].nil?
            validate_keys(key[:subkeys])
          end
        end
      end
    end

    def check_rules_are_loaded
      if @rules.nil? && @rules.instance_of?(Hash)
        msg = 'Cannot validate, rules file not loaded!'
        raise YamlBot::ValidationError.new(msg)
      end
    end

    def validate_accepted_types(key_hash)
      allowed_values = YAML.load(File.open(
                                 File.dirname(
                                 File.realpath(__FILE__)) +
                                 '/resources/valid_accepted_types.yml'))

      key_hash[:accepted_types].each do |type|
        unless allowed_values.include?(type)
          msg = "Invalid value for key: #{type}\n"
          msg += "Valid key values are #{allowed_values}"
          raise YamlBot::ValidationError.new(msg)
        end
      end
    end
  end
end
