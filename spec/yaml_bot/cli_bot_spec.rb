require 'spec_helper'
require 'yaml_bot/cli_bot'

describe YamlBot::CLIBot do
  describe '#run' do
    context 'Successful YAML validation' do
      it 'returns a zero exit code' do
        opts = {}
        opts[:file] = File.dirname(File.realpath(__dir__)) +
                      '/fixtures/valid_yaml.yml'
        opts[:rules] = File.dirname(File.realpath(__dir__)) +
                       '/fixtures/valid_rules.yml'
        cli_bot = YamlBot::CLIBot.new(opts)
        expect(cli_bot.run).to eq(0)
      end
    end

    context 'Failed YAML validation' do
      it 'returns a non-zero exit code' do
        opts = {}
        opts[:file] = File.dirname(File.realpath(__dir__)) +
                      '/fixtures/invalid_yaml_invalid_type.yml'
        opts[:rules] = File.dirname(File.realpath(__dir__)) +
                       '/fixtures/valid_rules.yml'
        cli_bot = YamlBot::CLIBot.new(opts)
        expect(cli_bot.run).to eq(1)
      end
    end

    after :each do
      @cli_bot = nil
    end
  end
end
