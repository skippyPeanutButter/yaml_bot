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
          validate_subkeys_or_accepted_types(yaml, key, keys, index, ancestors)
        else
          ancestors = ancestors.join('.')
          log_missing_key(key_type, ancestors)
        end
      end
    end

    def validate_subkeys_or_accepted_types(yaml, key, keys, index, ancestors)
      if !keys[index][key][:subkeys].nil?
        validate_subkeys(yaml, key, keys, index, ancestors)
      else
        validate_accepted_types_or_key_values(yaml[key],
                                              keys[index][key],
                                              ancestors)
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

    def validate_accepted_types_or_key_values(value, key_block, ancestors)
      types = key_block[:accepted_types]
      key_values = key_block[:values]
      validate_key_values(value, key_values, ancestors) unless key_values.nil?
      validate_accepted_types(value, types, ancestors) unless types.nil?
    end

    def validate_existance_of_rules_and_yaml_files
      return unless rules.nil? || yaml_file.nil?
      msg = "Rules file, or Yaml file is not set\n"
      raise YamlBot::ValidationError, msg
    end

    def validate_accepted_types(value, types, ancestors)
      if types.include?(value.class.to_s)
        msg = "Key: '#{ancestors.join('.')}' contains a value of a valid type "\
              "#{value.class}"
        log_successful_key_validation(msg)
      else
        msg = "Value: '#{value}' of class #{value.class} is not a valid type "\
              "for key: '#{ancestors.join('.')}'\n"
        msg += "Valid types for key '#{ancestors.join('.')}' include #{types}\n"
        log_failed_key_validation(msg)
      end
    end

    def validate_key_values(value, key_values, ancestors)
      if key_values.include?('*') || key_values.include?(value)
        msg = "Key: '#{ancestors.join('.')}' contains valid value #{value}"
        log_successful_key_validation(msg)
      else
        msg = "Key: '#{ancestors.join('.')}' contains invalid value #{value}\n"
        msg += "Valid values include #{key_values}"
        log_failed_key_validation(msg)
      end
    end

    def log_missing_key(key_type, ancestors)
      if key_type == :required
        self.violations += 1
        logger.error "Missing required key: '#{ancestors}'"
      else
        logger.warn "Optional key: '#{ancestors}' not utilized"
      end
    end

    def log_successful_key_validation(msg)
      logger.info msg
    end

    def log_failed_key_validation(msg)
      self.violations += 1
      logger.error msg
    end
  end
end
