require 'spec_helper'
require 'active_support/hash_with_indifferent_access'

describe YamlBot::ValidationBot do
  before :each do
    @yaml_bot  = YamlBot::ValidationBot.new
  end

  it 'is initialized with 0 violations' do
    expect(@yaml_bot.violations).to eq(0)
  end

  describe '#scan' do
    context 'missing required files' do
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

    context 'yaml files violating yamlbot rules file specification' do
      it 'logs an error message and increases the violation count when a key has a value of an invalid type'
      it 'logs an error message and increases the violation count when a required key is missing'
    end

    context 'yaml files are successfully validated' do
      
    end
  end
end
