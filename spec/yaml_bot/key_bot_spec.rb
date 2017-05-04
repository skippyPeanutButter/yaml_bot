require 'spec_helper'

describe YamlBot::KeyBot do
  describe '#validate' do
    context 'Valid yaml file' do
      before :each do
        file_name = File.dirname(File.realpath(__FILE__)) +
                    '/../fixtures/valid_yaml.yml'
        rules_file_name = File.dirname(File.realpath(__FILE__)) +
                          '/../fixtures/valid_rules.yml'
        yaml = YAML.load_file(file_name)
        rules = YAML.load_file(rules_file_name)
        defaults = rules['defaults']
        @keys = rules['rules']
        @keybot = YamlBot::KeyBot.new(nil, yaml, defaults)
      end

      it 'should return 0 with a valid key' do
        @keys.each do |key|
          @keybot.key = key
          expect(@keybot.validate).to eq(0)
        end
      end
    end

    context 'Invalid yaml file' do
      it 'should return a violation if a required key is missing' do
        file_name = File.dirname(File.realpath(__FILE__)) +
                    '/../fixtures/invalid_yaml_missing_required_key.yml'
        rules_file_name = File.dirname(File.realpath(__FILE__)) +
                          '/../fixtures/valid_rules.yml'
        yaml = YAML.load_file(file_name)
        rules = YAML.load_file(rules_file_name)
        key = rules['rules'].first
        defaults = rules['defaults']
        @keybot = YamlBot::KeyBot.new(key, yaml, defaults)

        expect(@keybot.validate).to eq(1)
      end

      it 'should return a violation if a key is missing required complement keys' do
        file_name = File.dirname(File.realpath(__FILE__)) +
                    '/../fixtures/invalid_yaml_missing_and_requires_key.yml'
        rules_file_name = File.dirname(File.realpath(__FILE__)) +
                          '/../fixtures/valid_rules_and_requires.yml'
        yaml = YAML.load_file(file_name)
        rules = YAML.load_file(rules_file_name)
        key = rules['rules'].first
        defaults = rules['defaults']
        @keybot = YamlBot::KeyBot.new(key, yaml, defaults)

        expect(@keybot.validate).to eq(1)
      end
    end
  end

  after :each do
    @keybot = nil
  end
end
