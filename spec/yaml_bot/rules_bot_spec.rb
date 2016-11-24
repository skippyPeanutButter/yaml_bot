require 'spec_helper'
require 'yaml'
require 'yaml_bot/validation_error'

describe YamlBot::RulesBot do
  describe '.scan' do
    it 'prints a message when the required root key is missing' do
      rules = YAML.load(File.open(File.dirname(File.realpath(__FILE__)) +
              '/../fixtures/rules_file_missing_required_root_key.yml'))
      msg = 'No required keys specified.'
      expect { YamlBot::RulesBot.scan(rules) }.to output(/#{msg}/).to_stdout
    end

    it 'prints a message when the optional root key is missing' do
      rules = YAML.load(File.open(File.dirname(File.realpath(__FILE__)) +
              '/../fixtures/rules_file_missing_optional_root_key.yml'))
      msg = 'No optional keys specified.'
      expect { YamlBot::RulesBot.scan(rules) }.to output(/#{msg}/).to_stdout
    end

    it 'raises ValidationError if missing both required and optional root keys' do
      rules = YAML.load(File.open(File.dirname(File.realpath(__FILE__)) +
              '/../fixtures/rules_file_missing_root_keys.yml'))
      expect { YamlBot::RulesBot.scan(rules) }.to raise_error(YamlBot::ValidationError)
    end
  end
end
