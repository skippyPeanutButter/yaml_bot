require 'spec_helper'
require 'yaml'
require 'yaml_bot/validation_error'

describe YamlBot::RulesBot do
  before :each do
    @rules_bot = YamlBot::RulesBot.new
  end

  describe '#validate_rules' do
    it 'prints a message when a rules file is validated' do
      file_name = File.dirname(File.realpath(__FILE__)) +
                  '/../fixtures/valid_rules_file.yml'
      @rules_bot.rules = YAML.load(File.open(file_name)).deep_symbolize_keys
      msg = 'Rules file validated.'
      expect { @rules_bot.validate_rules }.to output(/#{msg}/).to_stdout
    end

    it 'throws a ValidationError when a rules file is invalid' do
      file_name = File.dirname(File.realpath(__FILE__)) +
                  '/../fixtures/rules_file_invalid_type.yml'
      @rules_bot.rules = YAML.load(File.open(file_name)).deep_symbolize_keys
      expect do
        @rules_bot.validate_rules
      end.to raise_error(YamlBot::ValidationError)
    end
  end
end
