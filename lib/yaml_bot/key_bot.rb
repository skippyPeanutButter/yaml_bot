module YamlBot
  class KeyBot
    attr_accessor :defaults, :invalid, :key, :yaml_file

    def initialize(key, yaml_file, defaults = nil)
      self.key = key
      self.yaml_file = yaml_file
      self.defaults = defaults
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
        @invalid = true
      end
    end

    def check_and_requires
      return if key['and_requires'].nil?
      key['and_requires'].each do |k|
        result = get_object_value(yaml_file, k)
        if result.nil?
          @invalid = true
          break
        end
      end
    end

    def check_or_requires
      if !key['or_requires'].nil?
        # check or requirements
      end
    end

    def check_val_whitelist
      if !key['value_whitelist'].nil?
        # check value_whitelist
      end
    end

    def check_val_blacklist
      if !key['value_blacklist'].nil?
        # check value_blacklist
      end
    end

    def check_types
      if !key['types'].nil?
        # check types
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
