require 'spec_helper'
require 'active_support/hash_with_indifferent_access'

describe YamlBot::ValidationBot do
  describe '#scan' do
    before :each do
      @yaml_bot  = YamlBot::ValidationBot.new
    end

    it 'raises a validation error when a yamlbot file is not set' do
      rules = YAML.load(File.open(File.dirname(File.realpath(__FILE__)) +
              '/../fixtures/valid_rules_file.yml'))
      @yaml_bot.rules = rules
      expect { @yaml_bot.scan }.to raise_error(YamlBot::ValidationError)
    end

    it 'raises a validation error when a rules file is not set' do
      yaml  = YAML.load(File.open(File.dirname(File.realpath(__FILE__)) +
               '/../fixtures/valid_yaml_bot_file.yml'))
      @yaml_bot.yaml_file = yaml
      expect { @yaml_bot.scan }.to raise_error(YamlBot::ValidationError)
    end
  end
end
