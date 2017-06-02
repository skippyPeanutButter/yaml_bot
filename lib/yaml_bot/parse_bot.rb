module YamlBot
  class ParseBot
    def self.get_object_value(yaml, key_addr)
      if !key_addr.index('.').nil? && key_addr.index('.') >= 0
        key1, key2 = key_addr.split('.', 2)
        return get_object_value(yaml[key1], key2) if !yaml[key1].nil? && yaml[key1].instance_of?(Hash)
        return nil
      end

      return to_boolean(yaml[key_addr]) if %w(true false).include?(yaml[key_addr])
      yaml[key_addr]
    rescue StandardError => e
      puts "Caught exception #{e}!"
    end

    private_class_method

    def self.to_boolean(val)
      val == 'true'
    end
  end
end
