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
      before :each do
        @yaml_bot  = YamlBot::ValidationBot.new
        rules = YAML.load(File.open(File.dirname(File.realpath(__FILE__)) +
                 '/../fixtures/valid_rules_file.yml'))
        @yaml_bot.rules = rules
      end

      it 'logs an error message and increases the violation count when a key has a value of an invalid type'
      it 'logs an error message and increases the violation count when a required key is missing' do
        violation_count = 0
        [
          'invalid_yaml_bot_file_missing_required_key1.yml',
          'invalid_yaml_bot_file_missing_required_key2.yml',
          'invalid_yaml_bot_file_missing_required_key3.yml'
        ].each do |file|
          yaml = YAML.load(File.open(File.dirname(File.realpath(__FILE__)) + "/../fixtures/#{file}"))
          @yaml_bot.yaml_file = yaml
          msg = 'Missing required key: key'
          violation_count += 1

          expect { @yaml_bot.scan }.to output(/#{msg}/).to_stdout
          expect(@yaml_bot.violations).to eq(violation_count)
        end
      end
    end

    context 'yaml files are successfully validated' do

    end
  end
end
