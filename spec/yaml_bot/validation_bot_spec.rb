require 'spec_helper'
require 'active_support/core_ext/hash/keys'

describe YamlBot::ValidationBot do
  before :each do
    @yaml_bot = YamlBot::ValidationBot.new
  end

  it 'is initialized with 0 violations' do
    expect(@yaml_bot.violations).to eq(0)
  end

  describe '#scan' do
    context 'missing required files' do
      it 'raises a validation error when a yamlbot file is not set' do
        file = 'valid_rules_file.yml'
        rules = YAML.load(File.open(
                          File.dirname(
                          File.realpath(__FILE__)) +
                          "/../fixtures/#{file}")
                          ).deep_symbolize_keys
        @yaml_bot.rules = rules
        expect { @yaml_bot.scan }.to raise_error(YamlBot::ValidationError)
      end

      it 'raises a validation error when a rules file is not set' do
        file = 'valid_yaml_file.yml'
        yaml = YAML.load(File.open(
                         File.dirname(
                         File.realpath(__FILE__)) +
                         "/../fixtures/#{file}")
                         ).deep_symbolize_keys
        @yaml_bot.yaml_file = yaml
        expect { @yaml_bot.scan }.to raise_error(YamlBot::ValidationError)
      end
    end

    context 'yaml files violating yamlbot rules file specification' do
      before :each do
        @yaml_bot  = YamlBot::ValidationBot.new
        rules = YAML.load(File.open(
                          File.dirname(
                          File.realpath(__FILE__)) +
                          '/../fixtures/valid_rules_file.yml')
                          ).deep_symbolize_keys
        @yaml_bot.rules = rules
      end

      it 'logs an error message and increases the violation count when a key '\
         'has a value of an invalid type' do
        rules = { root_keys: { required: [{ key: { accepted_types: ["Fixnum"]}}]}}
        yaml_file = { key: true }
        @yaml_bot.rules = rules
        @yaml_bot.yaml_file = yaml_file
        key = 'key'
        value = true
        msg = "Value: #{value} of class #{value.class} is not a valid type "\
              "for key: #{key}\n"

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
          yaml = YAML.load(File.open(
                           File.dirname(
                           File.realpath(__FILE__)) +
                           "/../fixtures/#{file}")
                           ).deep_symbolize_keys
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
        rules = 'valid_rules_file.yml'
        file = 'valid_yaml_file.yml'
        @yaml_bot.rules = YAML.load(File.open(
                                    File.dirname(
                                    File.realpath(__FILE__)) +
                                    "/../fixtures/#{rules}")
                                    ).deep_symbolize_keys
        @yaml_bot.yaml_file = YAML.load(File.open(
                                        File.dirname(
                                        File.realpath(__FILE__)) +
                                        "/../fixtures/#{file}")
                                        ).deep_symbolize_keys
        @yaml_bot.scan

        expect(@yaml_bot.violations).to eq(0)
      end
    end

    context 'rules files containing only optional keys' do
      it 'allows empty yaml files' do
        file = 'valid_rules_file_only_optional_keys.yml'
        @yaml_bot.rules = YAML.load(File.open(
                                    File.dirname(
                                    File.realpath(__FILE__)) +
                                    "/../fixtures/#{file}")
                                    ).deep_symbolize_keys
        @yaml_bot.yaml_file = {}
        @yaml_bot.scan

        expect(@yaml_bot.violations).to eq(0)
      end
    end
  end
end
