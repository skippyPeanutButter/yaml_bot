module YamlBot
  class ParseBot
    def self.get_object_value(yaml, key_addr)
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
  end
end
