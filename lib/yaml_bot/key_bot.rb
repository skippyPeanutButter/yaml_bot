require 'yaml_bot/parse_bot'

module YamlBot
  # KeyBot takes a keymap from a yamlbot rules file and validates
  # the specified yaml file against the rules of that map.
  class KeyBot
    attr_accessor :defaults, :invalid, :key, :yaml_file

    TYPE_MAP = {
      object: Hash,
      list: Array,
      string: String,
      number: [Integer, Float],
      boolean: [TrueClass, FalseClass]
    }.freeze

    VALIDATION_CHECKS = [
      :check_if_key_is_required,
      :check_and_requires,
      :check_or_requires,
      :check_val_whitelist,
      :check_val_blacklist,
      :check_types
    ].freeze

    def initialize(key, yaml_file, defaults)
      @defaults = defaults || {}
      @invalid = false
      @key = @defaults.merge(key)
      @yaml_file = yaml_file
    end

    def validate
      VALIDATION_CHECKS.each do |method|
        send(method)
        break if @invalid
      end
      @invalid ? 1 : 0
    end

    def check_if_key_is_required
      yaml_key = ParseBot.get_object_value(yaml_file, key['key'])
      return unless key['required_key'] && yaml_key.nil?
      return unless key['or_requires'].nil?
      @invalid = true
      puts "VIOLATION: Missing required key: #{key['key']}"
    end

    def check_and_requires
      yaml_key = ParseBot.get_object_value(yaml_file, key['key'])
      return if yaml_key.nil? || key['and_requires'].nil?
      key['and_requires'].each do |k|
        next unless ParseBot.get_object_value(yaml_file, k).nil?
        @invalid = true
        puts "VIOLATION: Key #{key['key']} requires that the following key(s)"
        puts "also be defined: #{key['and_requires']}"
        break
      end
    end

    # If the key being checked, or any of
    # the keys in the "or_requires" list
    # are in the yaml then check passes
    def check_or_requires
      return if key['or_requires'].nil?
      alt_key = search_for_alternate_key(key)
      value = ParseBot.get_object_value(yaml_file, key['key'])
      @invalid = value.nil? && alt_key.nil?
      return unless @invalid
      puts "VIOLATION: Key #{key['key']} or the following key(s)"
      puts "must be defined: #{key['and_requires']}"
    end

    def check_val_whitelist
      return if key['value_whitelist'].nil?
      value = ParseBot.get_object_value(yaml_file, key['key'])
      return if key['value_whitelist'].include?(value)
      @invalid = true
      puts "VIOLATION: Invalid value #{value} for whitelist #{key['value_whitelist']}\n"
    end

    def check_val_blacklist
      return if key['value_blacklist'].nil?
      value = ParseBot.get_object_value(yaml_file, key['key'])
      return unless key['value_blacklist'].include?(value)
      @invalid = true
      puts "VIOLATION: Blacklisted value specified #{value}\n"
    end

    def check_types
      return if key['types'].nil?
      value = ParseBot.get_object_value(yaml_file, key['key'])
      return if value.nil?
      @invalid = !value_is_a_valid_type?(key['types'], value)
      return unless @invalid
      puts "VIOLATION: Invalid value type specified for key: #{key['key']}"
      puts "#{value.class} given, valid types include #{key['types']}\n"
    end

    private

    def search_for_alternate_key(key_map)
      alt_key = nil
      key_map['or_requires'].each do |k|
        alt_key = ParseBot.get_object_value(yaml_file, k)
        return alt_key unless alt_key.nil?
      end
      alt_key
    end

    def value_is_a_valid_type?(types, value)
      types.any? do |type|
        type_value = TYPE_MAP[type.downcase.to_sym]
        return type_value.any? { |t| value.instance_of?(t) } if type_value.instance_of?(Array)
        return true if value.instance_of?(type_value)
      end
    end
  end
end
