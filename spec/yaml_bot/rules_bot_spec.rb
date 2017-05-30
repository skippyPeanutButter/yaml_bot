require 'spec_helper'
require 'yaml'
require 'yaml_bot/rules_bot'

describe YamlBot::RulesBot do
  describe '#validate_rules' do
    before :each do
      @rules_bot = YamlBot::RulesBot.new(nil)
    end

    it 'should raise an error when a rules file is not found' do
      expect { @rules_bot.validate_rules }.to raise_error(StandardError, '.yamlbot rules file is not set.')
    end

    context 'successful validation' do
      it 'should not raise an error when a rules file is successfully validated' do
        rules_file_name = File.dirname(File.realpath(__FILE__)) +
                          '/../fixtures/valid_rules.yml'
        @rules_bot.rules = YAML.load_file(rules_file_name)
        expect { @rules_bot.validate_rules }.not_to raise_error
      end
    end

    context 'failed validation' do
      it 'should raise a ValidationError when a rules file is missing the rules key'
      it 'should raise a ValidationError when a set of rules contains an unapproved key'
      it 'should raise a ValidationError when a set of rules is missing a key to validate'
    end

    after :each do
      @rules_bot = nil
    end
  end
end
