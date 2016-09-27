require 'yaml'
require 'yaml_bot'

module YamlBot
  class YamlBot
    @@violations = 0

    def self.violation
      @@violations += 1
    end

    def self.get_violations
      @@violations
    end

    def initialize(yaml_file, rules)
      @yaml_file  = YAML.load(File.open(yaml_file))
      @rules      = YAML.load(File.open(rules))
    end

    def scan
      # Validate .yamlbot/rules file
      check_root_keys(@rules, @yaml_file)
      check_opt_keys(@rules, @yaml_file)
      #raise
    end

    def check_root_keys(rules, yaml)
      if rules['root_keys']['required'].nil?
        return
      end
      required_root_keys = rules['root_keys']['required'].keys
      required_root_keys.each do |k|
        if !yaml.keys.include?(k)
          puts "Missing required key #{k}\n\n"
          YamlBot.violation
        end
      end

      if !required_root_keys.empty?
        required_keys(rules['root_keys']['required'], yaml)
      end
    end

    def check_opt_keys(rules, yaml)
      if rules['root_keys']['optional'].nil?
        return
      end
      optional_root_keys = rules['root_keys']['optional'].keys
      optional_root_keys.each do |k|
        if !yaml.keys.include?(k)
          puts "Optional key #{k} not used\n\n"
        end
      end

      if !optional_root_keys.empty?

      end
    end

    def required_keys(rules, yaml)
      rules.each do |k, v|
        # puts "Checking key #{k}"
        # puts "Checking value #{v}"
        # puts "Checking yaml #{yaml[k]}"
        if !v['subkeys'].nil?
          if !v['subkeys']['required'].nil? && !yaml[k].nil?
            #required_keys(v['subkeys']['required'], yaml[k])
            if yaml[k].class == Hash
              required_keys(v['subkeys']['required'], yaml[k])
            elsif yaml[k].class == Array
              yaml[k].each_with_index do |inner_map, index|
                #puts "Checking map #{inner_map}"
                required_keys(v['subkeys']['required'], yaml[k][index])
              end
            end
          end
        else
          if !v['accepted_types'].nil?
            check_accepted_type(v['accepted_types'], yaml, k)
          end
        end
      end
    end

    def optional_keys(rules, yaml)

    end

    def check_accepted_type(type_list, yaml, key)
      if !type_list.include?(yaml[key].class.to_s)
        puts "Invalid type for key: #{key}"
        puts "Type given: #{yaml[key].class.to_s}"
        puts "Accepted types for #{key}: #{type_list}\n\n"
        YamlBot.violation
      end
    end
  end
end
