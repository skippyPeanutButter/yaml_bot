module YamlBot
  class KeyBot
    attr_accessor :defaults, :yaml_file, :key

    def initialize(key, yaml_file, defaults = nil)
      self.key = key
      self.yaml_file = yaml_file
      self.defaults = defaults
    end

    def validate

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
