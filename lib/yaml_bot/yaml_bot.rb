require 'yaml'

module YamlBot
  class YamlBot
    def initialize(yaml_file, rules)
      @yaml_file  = YAML.load(File.open(yaml_file))
      @rules      = YAML.load(File.open(rules))
    end

    def scan
      Bots::RulesBot.scan(@yaml_file, @rules)
    end
  end
end
