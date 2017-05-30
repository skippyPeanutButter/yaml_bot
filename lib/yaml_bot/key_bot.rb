module YamlBot
  class KeyBot
    attr_accessor :defaults, :invalid, :key, :yaml_file

    TYPE_MAP = {
      object: Hash,
      list: Array,
      string: String,
      number: [Integer, Float],
      boolean: [TrueClass, FalseClass]
    }

    def initialize(key, yaml_file, defaults)
      self.key = key
      self.yaml_file = yaml_file
      self.defaults = defaults || {}
      self.invalid = false
    end

    def validate
      [
        :check_if_key_is_required,
        :check_and_requires,
        :check_or_requires,
        :check_val_whitelist,
        :check_val_blacklist,
        :check_types
      ].each do |method|
        self.send(method)
        break if @invalid
      end
      @invalid ? 1 : 0
    end

    def check_if_key_is_required
      rules = defaults.merge(key)
      yaml_key = get_object_value(yaml_file, key['key'])
      if rules['required_key'] && yaml_key.nil?
        @invalid = true if rules['or_requires'].nil?
      end
    end

    def check_and_requires
      yaml_key = get_object_value(yaml_file, key['key'])
      return if yaml_key.nil? ||  key['and_requires'].nil?
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
      rules = defaults.merge(key)
      value = get_object_value(yaml_file, key['key'])
      return if key['or_requires'].nil?
      alt_key_found = false
      key['or_requires'].each do |k|
        result = get_object_value(yaml_file, k)
        unless result.nil?
          alt_key_found = true
        end
      end
      @invalid = true if value.nil? && !alt_key_found
    end

    def check_val_whitelist
      return if key['value_whitelist'].nil?
      value = get_object_value(yaml_file, key['key'])
      if !key['value_whitelist'].include?(value)
        @invalid = true
        puts "Invalid value #{value} for whitelist #{key['value_whitelist']}"
      end
    end

    def check_val_blacklist
      return if key['value_blacklist'].nil?
      value = get_object_value(yaml_file, key['key'])
      if key['value_blacklist'].include?(value)
        @invalid = true
        puts "Blacklisted value specified #{value}"
      end
    end

    def check_types
      return if key['types'].nil?
      value = get_object_value(yaml_file, key['key'])
      if key['types'].instance_of?(String)
        @invalid = !value.instance_of?(TYPE_MAP[key['types'].downcase.to_sym])
      else
        @invalid = !key['types'].any? do |type|
          type_value = TYPE_MAP[type.downcase.to_sym]
          if type_value.instance_of?(Array)
            type_value.each { |t| value.instance_of?(t) }
          else
            value.instance_of?(type_value)
          end
        end
      end

      if @invalid
        puts "Invalid value type specified: #{value.class}"
        puts "Valid types include #{key['types']}"
      end
    end

    private

    def get_object_value(yaml, key_addr)
      if !key_addr.index('.').nil? && key_addr.index('.') >= 0
        key1 = key_addr.split('.', 2)[0]
        key2 = key_addr.split('.', 2)[1]
        if !yaml[key1].nil? && yaml[key1].instance_of?(Hash)
          return get_object_value(yaml[key1], key2)
        else
          return nil
        end
      end

      begin
        if !yaml[key_addr].nil?
          # Check if default value is a Boolean type
          if yaml[key_addr] == 'false'
            return false
          else
            return yaml[key_addr]
          end
        else
          return nil
        end
      rescue
      end
    end
  end
end
