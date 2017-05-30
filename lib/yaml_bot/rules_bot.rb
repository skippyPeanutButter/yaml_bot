require 'yaml'
require 'yaml_bot/validation_error'

module YamlBot
  class RulesBot
    attr_accessor :rules

    def initialize(rules)
      @rules = rules
    end

    def validate_rules
      raise StandardError, '.yamlbot rules file is not set.' if @rules.nil?
      raise ValidationError, 'rules section not defined in .yamlbot file' if @rules['rules'].nil?
      validate_defaults if !@rules['defaults'].nil?
      if @rules['rules'].instance_of?(Array)
        @rules['rules'].each do |key_map|
          validate_key_map(key_map)
          puts "Key: #{key_map['key']} validated."
        end
      else
        msg = "The rules section of a rules file must define a list of keys.\n"
        raise ValidationError, msg
      end
      puts 'Rules file validated.'
    end

    private
    def validate_key_map(key_map)
      valid_keys = YAML.load_file(File.dirname(File.realpath(__FILE__)) +
                   '/resources/valid_rules_keys.yml')
      invalid_keys = []
      key_map.keys.each { |k| invalid_keys << k if !valid_keys.include?(k) }
      if !invalid_keys.empty?
        msg = "Invalid key(s) specified in rules file: #{invalid_keys}\n"
        msg += "Valid rules keys include: #{valid_keys}\n"
        raise ValidationError, msg
      end

      if key_map['key'].nil? || !key_map['key'].instance_of?(String)
        msg = "Missing required key 'key' within rules file.\n"
        msg += "Or a key name has a value that is not a String.\n"
        raise ValidationError, msg
      end

      merged_keys = {}.merge(key_map)
      merged_keys = @rules['defaults'].merge(key_map) if !@rules['defaults'].nil? && @rules['defaults'].instance_of?(Hash)
      if merged_keys['required_key'].nil? ||
        (!merged_keys['required_key'].instance_of?(TrueClass) && !merged_keys['required_key'].instance_of?(FalseClass))
        msg = "Missing required key 'required_key' for key: #{key_map['key']}.\n"
        msg += "Or 'required_key' has a value that is not a Boolean.\n"
        raise ValidationError, msg
      end
    end

    def validate_defaults
      valid_keys = YAML.load_file(File.dirname(File.realpath(__FILE__)) +
                   '/resources/valid_rules_keys.yml')
      invalid_keys = []
      @rules['defaults'].keys.each { |k| invalid_keys << k if !valid_keys.include?(k) }
      if !invalid_keys.empty?
        msg = "Invalid default(s) specified in rules file: #{invalid_keys}\n"
        msg += "Valid rules keys include: #{valid_keys}\n"
        raise ValidationError, msg
      end
    end
  end
end
