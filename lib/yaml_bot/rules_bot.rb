require 'yaml'

module YamlBot
  class RulesBot
    def self.scan(rules)
      @rules = rules
      scan_top_level_key
      scan_root_keys
    end

    private

    def self.scan_top_level_key
      root_key = @rules.keys
      unless root_key.include?('root_keys') && root_key.length == 1
        msg = "Invalid top level key error in rules file: #{root_key}\n"
        msg += "Valid top level key: 'root_keys'"
        msg += File.open(File.join(File.dirname(__FILE__), 'resources/valid_root_keys.template')).read
        raise msg
      end
    end

    def self.scan_root_keys
      keys = @rules['root_keys'].keys
      if !keys.include?('required') && !keys.include?('optional')
        msg = "Invalid top level keys in rules file: #{keys}\n"
        msg += File.open(File.join(File.dirname(__FILE__), 'resources/valid_root_keys.template')).read
        raise msg
      end
    end
  end
end
