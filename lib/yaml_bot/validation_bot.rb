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
      YamlBot::Logging.info 'Beginning scan...'

      if rules.nil? || yaml_file.nil?
        msg = "Rules file, or Yaml file is not set\n"
        raise YamlBot::ValidationError.new(msg)
      end

      if !rules[:root_keys][:required].nil?
        validate_keys yaml_file, rules[:root_keys][:required], [], 'required'
      end

      if !rules[:root_keys][:optional].nil?
        validate_keys yaml_file, rules[:root_keys][:optional], [], 'optional'
      end

      YamlBot::Logging.info 'Finished scanning...'
    end

    private

    def validate_keys(yaml, keys, parent_keys, key_type)
      keys.each_with_index do |key_map, index|
        key = key_map.keys.first
        puts "Validating key #{key}"
        ancestors = parent_keys.dup << key
        if yaml.keys.include?(key)
          if !keys[index][key][:subkeys].nil?
            if !keys[index][key][:subkeys][:required].nil?
              validate_keys yaml[key], keys[index][key][:subkeys][:required], ancestors, 'required'
            end

            if !keys[index][key][:subkeys][:optional].nil?
              validate_keys yaml[key], keys[index][key][:subkeys][:optional], ancestors, 'optional'
            end
          else
            if
              validate_accepted_types yaml[key], keys[index][key][:accepted_types], key
            end
          end
        else
          ancestors = ancestors.join('.')
          if key_type == 'required'
            self.violations += 1
            YamlBot::Logging.error "Missing required key: #{ancestors}"
          else
            YamlBot::Logging.info "Not utilizing optional key: #{ancestors}"
          end
        end
      end
    end

    def validate_accepted_types(value, accepted_types, key)
      if !accepted_types.include?(value.class.to_s)
        self.violations += 1
        msg = "Value: #{value} of class #{value.class} is not a valid type for key: #{key}\n"
        msg += "Valid types for key #{key} include: #{accepted_types}\n"
        YamlBot::Logging.error msg
      end
    end
  end
end
