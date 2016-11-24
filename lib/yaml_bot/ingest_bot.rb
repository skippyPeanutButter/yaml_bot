require 'yaml'
require 'yaml_bot/rules_bot'
require 'yaml_bot/logging'

module YamlBot
  class IngestBot
    @@violations = 0

    def self.violation
      @@violations += 1
    end

    def self.get_violations
      @@violations
    end

    def initialize(yaml_file, rules_file)
      @yaml_file  = YAML.load(File.open(yaml_file))
      @rules      = YAML.load(File.open(rules_file))
    end

    def scan
      # Validate .yamlbot/rules file
      RulesBot.scan(@rules)
      missing_required_keys = false
      missing_optional_keys = false
      if @rules['root_keys']['required'].nil?
        missing_required_keys = true
        info 'No required keys specified.'
      end
      if @rules['root_keys']['optional'].nil?
        missing_optional_keys = true
        info 'No optional keys specified.'
      end
    end
  end
end
