require 'yaml'
require 'yaml_bot/rules_bot'

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
      rules_bot = RulesBot.new
      rules_bot.rules = @rules
      rules_bot.validate_rules

    end
  end
end
