module YamlBot
  class KeyBot
    attr_accessor :defaults, :yaml_file, :key

    def initialize(key, yaml_file, defaults = nil)
      self.key = key
      self.yaml_file = yaml_file
      self.defaults = defaults
      self.valid = false
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
        break if @valid
      end
      @valid ? 0 : 1
    end

    def check_if_key_is_required
      rules = defaults.merge(key)
      if rules['required_key'] && !get_object_value(yaml_file, key['key'], nil).nil?
        @valid = true
      end
      if !rules['required_key']
        @valid = true
      end
    end

    def get_object_value(yaml, key, default_value)
      if key.index('.') >= 0
        key1 = key.split('.', 2)[0]
        key2 = key.split('.', 2)[1]
        if !yaml[key1].nil? && yaml[key1].instance_of?(Hash)
          get_object_value(yaml[key1], key2, default_value)
        else
          return default_value
        end
      end

      begin
        if !yaml[key].nil?
          if default_value.instance_of?(String)
             && (yaml[key].instance_of?(Hash) || yaml[key].instance_of?(Array))
            return default_value
          else
            # Check if default value is a Boolean type
            if !!default_value == default_value && yaml[key] == 'false'
              return false
            else
              return yaml[key]
            end
          end
        end
      rescue
      end

      default_value
    end
  end
end
