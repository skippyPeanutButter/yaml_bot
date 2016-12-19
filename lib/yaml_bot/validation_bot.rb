require 'yaml'
require 'yaml_bot/logging'
require 'yaml_bot/rules_bot'
require 'yaml_bot/validation_error'

module YamlBot
  class ValidationBot
    attr_accessor :rules, :yaml_file, :violations

    def initialize
      violations = 0
    end

    def scan
      if rules.nil? || yaml_file.nil?
        msg = "Rules file, or Yaml file is not set\n"
        raise YamlBot::ValidationError.new(msg)
      end

      if !rules['root_keys']['required'].nil?
        validate_required_keys yaml_file, rules['root_keys']['required']
      end

      if !rules['root_keys']['optional'].nil?
        validate_optional_keys yaml_file, rules['root_keys']['optional']
      end
    end

    private

    def validate_required_keys(yaml, required_keys)
      required_keys.each_with_index do |key_map, index|
        key = key_map.keys.first
        if yaml.keys.include?(key)
          if !required_keys[index][key]['subkeys'].nil?
            if !required_keys[index][key]['subkeys']['required'].nil?
              validate_required_keys yaml[key], required_keys[index][key]['subkeys']['required']
            end

            if !required_keys[index][key]['subkeys']['optional'].nil?
              validate_optional_keys yaml[key], required_keys[index][key]['subkeys']['optional']
            end
          else
            if
            validate_accepted_types yaml[key], required_keys[index][key]['accepted_types'], key
          end
        else
          violations = violations + 1
          YamlBot::Logging.error "Missing required key: #{key}"
        end
      end
    end

    def validate_optional_keys(yaml, optional_keys)
      optional_keys.each_with_index do |key_map, index|
        key = key_map.keys.first
        if yaml.keys.include?(key)
          if !optional_keys[index][key]['subkeys'].nil?
            if !optional_keys[index][key]['subkeys']['required'].nil?
              validate_required_keys yaml[key], optional_keys[index][key]['subkeys']['required']
            end

            if !optional_keys[index][key]['subkeys']['optional'].nil?
              validate_optional_keys yaml[key], optional_keys[index][key]['subkeys']['optional']
            end
          else
            if
            validate_accepted_types yaml[key], optional_keys[index][key]['accepted_types'], key
          end
        else
          YamlBot::Logging.info "Not utilizing optional key: #{key}"
        end
      end
    end

    def validate_accepted_types(value, accepted_types, key)
      if !accepted_types.include?(value.class.to_s)
        violations = violations + 1
        msg = "Value: #{value} is not a valid type for key: #{key}\n"
        msg += "Valid types for key #{key} include: #{accepted_types}\n"
        YamlBot::Logging.error msg
      end
    end
  end
end
