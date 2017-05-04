require 'yaml'
require 'yaml_bot/key_bot'

module YamlBot
  class ValidationBot
    attr_accessor :rules, :yaml_file, :violations, :logger

    def initialize
      self.violations = 0
    end

    def scan
      defaults = rules['defaults']
      rules['rules'].each do |item|
        key_bot = KeyBot.new(item, yaml_file, defaults)
        self.violations += key_bot.validate
      end
    end
  end
end
