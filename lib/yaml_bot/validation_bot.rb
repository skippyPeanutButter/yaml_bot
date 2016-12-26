require 'yaml'
require 'yaml_bot/logging'
require 'yaml_bot/rules_bot'
require 'yaml_bot/validation_error'

module YamlBot
  class ValidationBot
    attr_accessor :rules, :yaml_file, :violations

    def initialize
      self.violations = 0
    end

    def scan
      validate_existance_of_rules_and_yaml_files
      [:required, :optional].each do |key_type|
        next if rules[:root_keys][key_type].nil?
        validate_keys yaml_file, rules[:root_keys][key_type], [], key_type
      end
    end

    private

    def validate_keys(yaml, keys, parent_keys, key_type)
      keys.each_with_index do |key_map, index|
        key = key_map.keys.first
        ancestors = parent_keys.dup << key
        if yaml.keys.include?(key)
          check_if_key_contains_subkeys(yaml, key, keys, index, ancestors)
        else
          ancestors = ancestors.join('.')
          log_missing_key(key_type, ancestors)
        end
      end
    end

    def check_if_key_contains_subkeys(yaml, key, keys, index, ancestors)
      if !keys[index][key][:subkeys].nil?
        validate_subkeys(yaml, key, keys, index, ancestors)
      else
        validate_accepted_types(yaml[key],
                                keys[index][key][:accepted_types],
                                key)
      end
    end

    def validate_subkeys(yaml, key, keys, index, ancestors)
      [:required, :optional].each do |key_type|
        next if keys[index][key][:subkeys][key_type].nil?
        validate_keys(yaml[key],
                      keys[index][key][:subkeys][key_type],
                      ancestors,
                      key_type)
      end
    end

    def validate_existance_of_rules_and_yaml_files
      return unless rules.nil? || yaml_file.nil?
      msg = "Rules file, or Yaml file is not set\n"
      raise YamlBot::ValidationError, msg
    end

    def log_missing_key(key_type, ancestors)
      if key_type == :required
        self.violations += 1
        YamlBot::Logging.error "Missing required key: #{ancestors}"
      else
        YamlBot::Logging.info "Not utilizing optional key: #{ancestors}"
      end
    end

    def validate_accepted_types(value, accepted_types, key)
      return if accepted_types.include?(value.class.to_s)
      self.violations += 1
      msg = "Value: #{value} of class #{value.class} is not a valid type "\
            "for key: #{key}\n"
      msg += "Valid types for key #{key} include: #{accepted_types}\n"
      YamlBot::Logging.error msg
    end
  end
end
