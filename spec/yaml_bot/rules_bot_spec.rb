require 'spec_helper'
require 'yaml'
require 'yaml_bot/rules_bot'
require 'yaml_bot/validation_error'

describe YamlBot::RulesBot do
  describe '#validate_rules' do
    before :each do
      @rules_bot = YamlBot::RulesBot.new(nil)
    end

    def load_rules_file(file_path)
      @rules_bot.rules = YAML.load_file(file_path)
    end

    it 'should raise an error when a rules file is not found' do
      expect { @rules_bot.validate_rules }.to raise_error(YamlBot::ValidationError, '.yamlbot rules file is not set.')
    end

    context 'successful validation' do
      it 'should not raise an error when a rules file is successfully validated' do
        load_rules_file(File.dirname(File.realpath(__FILE__)) +
                        '/../fixtures/valid_rules.yml')
        expect { @rules_bot.validate_rules }.not_to raise_error
      end
    end

    context 'failed validation' do
      it 'should raise a ValidationError when a rules file has invalid defaults' do
        load_rules_file(File.dirname(File.realpath(__FILE__)) +
                        '/../fixtures/invalid_rules_invalid_default.yml')
        valid_keys = YAML.load_file(File.dirname(File.realpath(__FILE__)) +
                     '/../../lib/yaml_bot/resources/valid_rules_keys.yml')
        invalid_keys = ['invalid_key']
        msg = "Invalid key(s) specified in rules file: #{invalid_keys}\n"
        msg += "Valid rules keys include: #{valid_keys}\n"

        expect { @rules_bot.validate_rules }.to raise_error(YamlBot::ValidationError, msg)
      end

      it 'should raise a ValidationError when a set of rules contains an invalid key' do
        load_rules_file(File.dirname(File.realpath(__FILE__)) +
                        '/../fixtures/invalid_rules_invalid_rules_key.yml')
        valid_keys = YAML.load_file(File.dirname(File.realpath(__FILE__)) +
                     '/../../lib/yaml_bot/resources/valid_rules_keys.yml')
        invalid_keys = ['error_causing_key']
        msg = "Invalid key(s) specified in rules file: #{invalid_keys}\n"
        msg += "Valid rules keys include: #{valid_keys}\n"

        expect { @rules_bot.validate_rules }.to raise_error(YamlBot::ValidationError, msg)
      end

      it 'should raise a ValidationError when a rules file is missing the rules key' do
        load_rules_file(File.dirname(File.realpath(__FILE__)) +
                        '/../fixtures/invalid_rules_missing_rules.yml')
        invalid_keys = ['invalid_key']
        msg = 'rules section not defined in .yamlbot file'

        expect { @rules_bot.validate_rules }.to raise_error(YamlBot::ValidationError, msg)
      end

      it 'should raise a ValidationError when a set of rules is missing a key to validate' do
        load_rules_file(File.dirname(File.realpath(__FILE__)) +
                        '/../fixtures/invalid_rules_missing_key_from_list.yml')
        msg = "Missing required key 'key' within rules file.\n"
        msg += "Or a key name has a value that is not a String.\n"

        expect { @rules_bot.validate_rules }.to raise_error(YamlBot::ValidationError, msg)
      end

      it 'should raise a ValidationError when a set of rules is missing a key to validate' do
        load_rules_file(File.dirname(File.realpath(__FILE__)) +
                        '/../fixtures/invalid_rules_missing_key_from_list.yml')
        msg = "Missing required key 'key' within rules file.\n"
        msg += "Or a key name has a value that is not a String.\n"

        expect { @rules_bot.validate_rules }.to raise_error(YamlBot::ValidationError, msg)
      end

      it 'should raise a ValidationError when a key isn\'t specified as required/not-required and there are no defaults' do
        load_rules_file(File.dirname(File.realpath(__FILE__)) +
                        '/../fixtures/invalid_rules_missing_required_key.yml')
        key = 'jenkins.sudo'
        msg = "Missing required key 'required_key' for key: #{key}.\n"
        msg += "Or 'required_key' has a value that is not a Boolean.\n"

        expect { @rules_bot.validate_rules }.to raise_error(YamlBot::ValidationError, msg)
      end

      it 'should raise a ValidationError when \'required_key\' has a value that is not boolean' do
        load_rules_file(File.dirname(File.realpath(__FILE__)) +
                        '/../fixtures/invalid_rules_required_key_with_non_boolean_value.yml')
        key = 'language'
        msg = "Missing required key 'required_key' for key: #{key}.\n"
        msg += "Or 'required_key' has a value that is not a Boolean.\n"

        expect { @rules_bot.validate_rules }.to raise_error(YamlBot::ValidationError, msg)
      end
    end

    after :each do
      @rules_bot = nil
    end
  end
end
