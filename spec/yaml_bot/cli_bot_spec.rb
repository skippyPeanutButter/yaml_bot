require 'spec_helper'

describe YamlBot::CLIBot do
  before :each do
    rules = File.dirname(File.realpath(__FILE__)) +
            '/../fixtures/valid_rules_file.yml'
    yaml = File.dirname(File.realpath(__FILE__)) +
           '/../fixtures/valid_yaml_file.yml'
    @opts = {
      rules: rules,
      file: yaml
    }
    @cli_bot = YamlBot::CLIBot.new(@opts)
  end

  it 'initializes a logger, a RulesBot object, and a ValidationBot object' do
    expect(@cli_bot.logger_bot).to_not be nil
    expect(@cli_bot.validation_bot).to_not be nil
    expect(@cli_bot.rules_bot).to_not be nil
  end

  describe '#run' do
    context 'Successful validation of a yaml file' do
      it 'returns a zero exit code' do
        expect(@cli_bot.run).to eq(0)
      end
    end

    context 'Failed validation of a yaml file' do
      it 'returns a non-zero exit code' do
        path = '/../fixtures/invalid_yaml_bot_file_missing_required_key1.yml'
        bad_yaml_file = File.dirname(File.realpath(__FILE__)) + path
        @opts[:file] = bad_yaml_file

        expect(@cli_bot.run).to eq(1)
      end
    end
  end
end
