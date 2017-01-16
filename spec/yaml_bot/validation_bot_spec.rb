require 'spec_helper'
require 'active_support/core_ext/hash/keys'
require 'stringio'

ESCAPES = { green: "\033[32m",
            yellow: "\033[33m",
            red: "\033[31m",
            reset: "\033[0m" }.freeze

describe YamlBot::ValidationBot do
  before :each do
    @yaml_bot = YamlBot::ValidationBot.new
    @yaml_bot.logger = YamlBot::LoggingBot.new(StringIO.new)
  end

  it 'is initialized with 0 violations' do
    expect(@yaml_bot.violations).to eq(0)
  end

  describe '#scan' do
    context 'missing required files' do
      it 'raises a validation error when a yamlbot file is not set' do
        file_name = File.dirname(File.realpath(__FILE__)) +
                    '/../fixtures/valid_rules_file.yml'
        rules = YAML.load(File.open(file_name)).deep_symbolize_keys
        @yaml_bot.rules = rules

        expect { @yaml_bot.scan }.to raise_error(YamlBot::ValidationError)
      end

      it 'raises a validation error when a rules file is not set' do
        file_name = File.dirname(File.realpath(__FILE__)) +
                    '/../fixtures/valid_rules_file.yml'
        yaml = YAML.load(File.open(file_name)).deep_symbolize_keys
        @yaml_bot.yaml_file = yaml

        expect { @yaml_bot.scan }.to raise_error(YamlBot::ValidationError)
      end
    end

    context 'yaml files violating yamlbot rules file specification' do
      before :each do
        file_name = File.dirname(File.realpath(__FILE__)) +
                    '/../fixtures/valid_rules_file.yml'
        rules = YAML.load(File.open(file_name)).deep_symbolize_keys
        @yaml_bot.rules = rules
      end

      it 'logs an error message and increases the violation count when a key '\
         'has a value of an invalid type' do
        rules = {
          root_keys: { required: [{ key: { accepted_types: ['Fixnum'] } }] }
        }
        yaml_file = { key: true }
        @yaml_bot.rules = rules
        @yaml_bot.yaml_file = yaml_file
        key = 'key'
        value = true
        msg = "Value: '#{value}' of class #{value.class} is not a valid type "\
              "for key: '#{key}'\n"

        expect { @yaml_bot.scan }.to output(/#{msg}/).to_stdout
        expect(@yaml_bot.violations).to eq(1)
      end

      it 'logs an error message and increases the violation count when a '\
          'required key is missing' do
        violation_count = 0
        [
          'invalid_yaml_bot_file_missing_required_key1.yml',
          'invalid_yaml_bot_file_missing_required_key2.yml',
          'invalid_yaml_bot_file_missing_required_key3.yml'
        ].each do |file|
          file_name = File.dirname(File.realpath(__FILE__)) +
                      "/../fixtures/#{file}"
          yaml = YAML.load(File.open(file_name)).deep_symbolize_keys
          @yaml_bot.yaml_file = yaml
          msg = 'Missing required key:'
          violation_count += 1

          expect { @yaml_bot.scan }.to output(/#{msg}/).to_stdout
          expect(@yaml_bot.violations).to eq(violation_count)
        end
      end
    end

    context 'yaml files that are successfully validated' do
      it 'counts zero violations' do
        rules_file_name = File.dirname(File.realpath(__FILE__)) +
                          '/../fixtures/valid_rules_file.yml'
        yaml_file_name = File.dirname(File.realpath(__FILE__)) +
                         '/../fixtures/valid_yaml_file.yml'
        @yaml_bot.rules = YAML.load(
          File.open(rules_file_name)
        ).deep_symbolize_keys
        @yaml_bot.yaml_file = YAML.load(
          File.open(yaml_file_name)
        ).deep_symbolize_keys
        @yaml_bot.scan

        expect(@yaml_bot.violations).to eq(0)
      end

      it 'logs a message for each successfully validated key' do
        rules_file_name = File.dirname(File.realpath(__FILE__)) +
                          '/../fixtures/valid_rules_file.yml'
        yaml = { key1: { subkey1: 'value1', subkey2: 42 }, key2: 'value2' }
        msgs = [
          "Key: 'key1.subkey1' contains a value of a valid type String",
          "Key: 'key1.subkey2' contains a value of a valid type Fixnum",
          "Key: 'key2' contains a value of a valid type String"
        ]
        @yaml_bot.rules = YAML.load(
          File.open(rules_file_name)
        ).deep_symbolize_keys
        @yaml_bot.yaml_file = yaml

        msgs.each do |msg|
          expect { @yaml_bot.scan }.to output(/#{msg}/).to_stdout
        end
      end

      it 'validates keys with accepted_types' do
        file_name = '/../fixtures/valid_rules_file_with_only_accepted_types.yml'
        rules_file_name = File.dirname(File.realpath(__FILE__)) + file_name
        yaml = { language: 'go' }
        msg = "Key: 'language' contains a value of a valid type String"
        @yaml_bot.rules = YAML.load(
          File.open(rules_file_name)
        ).deep_symbolize_keys
        @yaml_bot.yaml_file = yaml

        expect { @yaml_bot.scan }.to output(/#{msg}/).to_stdout
      end

      it 'validates key values against a list of values' do
        file_name = '/../fixtures/valid_rules_file_with_only_values.yml'
        rules_file_name = File.dirname(File.realpath(__FILE__)) + file_name
        yaml = { language: 'go' }
        msg = "Key: 'language' contains valid value go"
        @yaml_bot.rules = YAML.load(
          File.open(rules_file_name)
        ).deep_symbolize_keys
        @yaml_bot.yaml_file = yaml

        expect { @yaml_bot.scan }.to output(/#{msg}/).to_stdout
      end

      it 'validates keys with accepted_types and values' do
        file_name = '/../fixtures/valid_rules_file_with_types_and_values.yml'
        rules_file_name = File.dirname(File.realpath(__FILE__)) + file_name
        yaml = { language: 'go' }
        msg = "Key: 'language' contains valid value go\n"
        msg += "Key: 'language' contains a value of a valid type String\n"
        @yaml_bot.rules = YAML.load(
          File.open(rules_file_name)
        ).deep_symbolize_keys
        @yaml_bot.yaml_file = yaml

        expect { @yaml_bot.scan }.to output(msg).to_stdout
      end
    end

    context 'rules files containing only optional keys' do
      it 'allows empty yaml files' do
        file_name = File.dirname(File.realpath(__FILE__)) +
                    '/../fixtures/valid_rules_file_only_optional_keys.yml'
        @yaml_bot.rules = YAML.load(File.open(file_name)).deep_symbolize_keys
        @yaml_bot.yaml_file = {}
        @yaml_bot.scan

        expect(@yaml_bot.violations).to eq(0)
      end
    end
  end
end
