require 'yaml'
require 'yaml_bot/key_bot'

module YamlBot
  class ValidationBot
    attr_accessor :rules, :yaml_file, :violations, :logger

    def initialize(rules = nil, yaml_file = nil)
      @rules = rules || {}
      @yaml_file = yaml_file || {}
      @violations = 0
    end

    def scan
      defaults = rules['defaults']
      rules['rules'].each do |item|
        key_bot = KeyBot.new(item, yaml_file, defaults)
        @violations += key_bot.validate
      end
      @violations
    end
  end
end
