require 'spec_helper'
require 'yaml'
require 'yaml_bot/validation_error'

describe YamlBot::RulesBot do
  describe '#validate_rules' do
    before :each do
      @rules_bot = YamlBot::RulesBot.new
    end

    it 'prints a message when a rules file is validated' do
      file = 'valid_rules_file.yml'
      @rules_bot.rules = YAML.load(File.open(File.dirname(
                                   File.realpath(__FILE__)) +
                                   "/../fixtures/#{file}"))
      msg = 'Rules file validated.'
      expect { @rules_bot.validate_rules }.to output(/#{msg}/).to_stdout
    end

    it 'throws a ValidationError when a rules file is invalid' do
      file = 'rules_file_invalid_type.yml'
      @rules_bot.rules = YAML.load(File.open(File.dirname(
                                   File.realpath(__FILE__)) +
                                   "/../fixtures/#{file}"))
      expect { @rules_bot.validate_rules
              }.to raise_error(YamlBot::ValidationError)
    end
  end

  describe '#validate_root_keys' do
    before :each do
      @rules_bot = YamlBot::RulesBot.new
    end

    it 'prints a message when the required root key is missing' do
      file = 'rules_file_missing_required_root_key.yml'
      @rules_bot.rules = YAML.load(File.open(File.dirname(
                                   File.realpath(__FILE__)) +
                                   "/../fixtures/#{file}"))
      msg = 'No required keys specified.'
      expect { @rules_bot.validate_root_keys }.to output(/#{msg}/).to_stdout
    end

    it 'prints a message when the optional root key is missing' do
      file = 'rules_file_missing_optional_root_key.yml'
      @rules_bot.rules = YAML.load(File.open(File.dirname(
                                             File.realpath(__FILE__)) +
                                             "/../fixtures/#{file}"))
      msg = 'No optional keys specified.'
      expect { @rules_bot.validate_root_keys }.to output(/#{msg}/).to_stdout
    end

    it 'raises ValidationError if missing both required and '\
       'optional root keys' do
      file = 'rules_file_missing_root_keys.yml'
      @rules_bot.rules = YAML.load(File.open(File.dirname(
                                             File.realpath(__FILE__)) +
                                             "/../fixtures/#{file}"))
      expect { @rules_bot.validate_root_keys
              }.to raise_error(YamlBot::ValidationError)
    end
  end

  describe '#validate_accepted_types' do
    before :each do
      @rules_bot = YamlBot::RulesBot.new
    end

    it 'raises a ValidationError when it finds an invalid accepted type' do
      type = {'accepted_types'=>['Invalid_type']}
      expect{ @rules_bot.validate_accepted_types(type)
            }.to raise_error(YamlBot::ValidationError)
    end

    it 'raises no ValidationError when it does not find an invalid '\
       'accepted type' do
      type = {'accepted_types'=>['Fixnum', 'String']}
      expect{ @rules_bot.validate_accepted_types(type) }.not_to raise_error
    end
  end
end
