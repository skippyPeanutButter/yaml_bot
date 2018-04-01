require 'yaml'
require 'yaml_bot/validation_error'

module YamlBot
  # RulesBot accepts a yamlbot rules file and validates that it is
  # inline with the specification given in the RULES_DEFINITION.md file.
  class RulesBot
    attr_accessor :rules

    def initialize(rules = nil)
      @rules = rules
    end

    def validate_rules
      raise ValidationError, '.yamlbot rules file is not set.' if @rules.nil?
      raise ValidationError, 'rules section not defined in .yamlbot file' if @rules['rules'].nil?
      validate_rules_keys(@rules['defaults']) unless @rules['defaults'].nil?
      if @rules['rules'].instance_of?(Array)
        validate_each_key_rule
      else
        msg = "The rules section of a rules file must define a list of keys.\n"
        raise ValidationError, msg
      end
    end

    private

    def validate_each_key_rule
      @rules['rules'].each do |key_map|
        validate_key_map(key_map)
        puts "Key: #{key_map['key']} validated."
      end
    end

    def validate_key_map(key_map)
      validate_rules_keys(key_map)
      validate_key_exists_and_is_string(key_map)
      validate_required_key_exists_and_is_bool(key_map)
    end

    def validate_rules_keys(key_map)
      valid_keys = YAML.load_file(File.dirname(File.realpath(__dir__)) +
                   '/yaml_bot/resources/valid_rules_keys.yml')
      invalid_keys = []
      key_map.keys.each { |k| invalid_keys << k unless valid_keys.include?(k) }
      return if invalid_keys.empty?
      msg = "Invalid key(s) specified in rules file: #{invalid_keys}\n"
      msg += "Valid rules keys include: #{valid_keys}\n"
      raise ValidationError, msg
    end

    def validate_key_exists_and_is_string(key_map)
      return unless key_map['key'].nil? || !key_map['key'].instance_of?(String)
      msg = "Missing required key 'key' within rules file.\n"
      msg += "Or a key name has a value that is not a String.\n"
      raise ValidationError, msg
    end

    def validate_required_key_exists_and_is_bool(key_map)
      merged_keys = {}.merge(key_map)
      merged_keys = @rules['defaults'].merge(key_map) unless @rules['defaults'].nil?
      return unless merged_keys['required_key'].nil? || !boolean?(merged_keys['required_key'])
      msg = "Missing required key 'required_key' for key: #{key_map['key']}.\n"
      msg += "Or 'required_key' has a value that is not a Boolean.\n"
      raise ValidationError, msg
    end

    def boolean?(arg)
      arg.instance_of?(TrueClass) || arg.instance_of?(FalseClass)
    end
  end
end
