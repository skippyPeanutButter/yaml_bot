require 'yaml_bot/parse_bot'

module YamlBot
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
      @key = key
      @yaml_file = yaml_file
      @defaults = defaults || {}
      @invalid = false
    end

    def validate
      VALIDATION_CHECKS.each do |method|
        send(method)
        break if @invalid
      end
      @invalid ? 1 : 0
    end

    def check_if_key_is_required
      rules = defaults.merge(key)
      yaml_key = ParseBot.get_object_value(yaml_file, key['key'])
      return unless rules['required_key'] && yaml_key.nil?
      @invalid = true if rules['or_requires'].nil?
    end

    def check_and_requires
      yaml_key = ParseBot.get_object_value(yaml_file, key['key'])
      return if yaml_key.nil? || key['and_requires'].nil?
      key['and_requires'].each do |k|
        result = ParseBot.get_object_value(yaml_file, k)
        if result.nil?
          @invalid = true
          break
        end
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
    end

    def check_val_whitelist
      return if key['value_whitelist'].nil?
      value = ParseBot.get_object_value(yaml_file, key['key'])
      return if key['value_whitelist'].include?(value)
      @invalid = true
      puts "Invalid value #{value} for whitelist #{key['value_whitelist']}\n"
    end

    def check_val_blacklist
      return if key['value_blacklist'].nil?
      value = ParseBot.get_object_value(yaml_file, key['key'])
      return unless key['value_blacklist'].include?(value)
      @invalid = true
      puts "Blacklisted value specified #{value}\n"
    end

    def check_types
      return if key['types'].nil?
      value = ParseBot.get_object_value(yaml_file, key['key'])
      @invalid = !value_is_a_valid_type?(key['types'], value)
      puts "CHECKING #{key['key']} with value #{value} and invalid #{@invalid}"
      return unless @invalid
      puts "Invalid value type specified for key: #{key['key']}"
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
