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
      yaml_key = get_object_value(yaml_file, key['key'])
      return unless rules['required_key'] && yaml_key.nil?
      @invalid = true if rules['or_requires'].nil?
    end

    def check_and_requires
      yaml_key = get_object_value(yaml_file, key['key'])
      return if yaml_key.nil? || key['and_requires'].nil?
      key['and_requires'].each do |k|
        result = get_object_value(yaml_file, k)
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
      value = get_object_value(yaml_file, key['key'])
      @invalid = value.nil? && alt_key.nil?
    end

    def check_val_whitelist
      return if key['value_whitelist'].nil?
      value = get_object_value(yaml_file, key['key'])
      return if key['value_whitelist'].include?(value)
      @invalid = true
      puts "Invalid value #{value} for whitelist #{key['value_whitelist']}"
    end

    def check_val_blacklist
      return if key['value_blacklist'].nil?
      value = get_object_value(yaml_file, key['key'])
      return unless key['value_blacklist'].include?(value)
      @invalid = true
      puts "Blacklisted value specified #{value}"
    end

    def check_types
      return if key['types'].nil?
      types = key['types']
      value = get_object_value(yaml_file, key['key'])
      @invalid = !value_within_list_of_types?(types, value)
      return unless @invalid
      puts "Invalid value type specified: #{value.class}"
      puts "Valid types include #{key['types']}"
    end

    def get_object_value(yaml, key_addr)
      if !key_addr.index('.').nil? && key_addr.index('.') >= 0
        key1 = key_addr.split('.', 2)[0]
        key2 = key_addr.split('.', 2)[1]
        return get_object_value(yaml[key1], key2) if !yaml[key1].nil? && yaml[key1].instance_of?(Hash)
        return nil
      end

      begin
        return nil if yaml[key_addr].nil?
        # Check if default value is a Boolean type
        return false if yaml[key_addr] == 'false'
        return yaml[key_addr]
      rescue StandardError => e
        puts "Caught exception #{e}!"
      end
    end

    private

    def search_for_alternate_key(key_map)
      alt_key = nil
      key_map['or_requires'].each do |k|
        alt_key = get_object_value(yaml_file, k)
        return alt_key unless alt_key.nil?
      end
      alt_key
    end

    def value_within_list_of_types?(types, value)
      types.any? do |type|
        type_value = TYPE_MAP[type.downcase.to_sym]
        type_value.each { |t| value.instance_of?(t) } if type_value.instance_of?(Array)
        value.instance_of?(type_value)
      end
    end
  end
end
