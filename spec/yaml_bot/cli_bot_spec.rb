require 'spec_helper'
require 'stringio'

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
    context 'No options are passed' do
      before :each do
        @opts = {}
        @cli_bot = YamlBot::CLIBot.new(@opts)
      end

      it 'exits with a non-zero exit code' do
        begin
          @cli_bot.run
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end
    end

    context 'No/bad yaml file path is passed' do
      before :each do
        rules = File.dirname(File.realpath(__FILE__)) +
                '/../fixtures/valid_rules_file.yml'
        yaml = File.dirname(File.realpath(__FILE__)) +
               '/../fixtures/non_existant_file.yml'
        @opts = {
          rules: rules,
          file: yaml
        }
        @cli_bot = YamlBot::CLIBot.new(@opts)
      end

      it 'exits with a non-zero exit code' do
        begin
          @cli_bot.run
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end
    end

    context 'Bad rules file path is passed' do
      before :each do
        rules = File.dirname(File.realpath(__FILE__)) +
                '/../fixtures/non_existant_file.yml'
        yaml = File.dirname(File.realpath(__FILE__)) +
               '/../fixtures/valid_yaml_file.yml'
        @opts = {
          rules: rules,
          file: yaml
        }
        @cli_bot = YamlBot::CLIBot.new(@opts)
      end

      it 'exits with a non-zero exit code' do
        begin
          @cli_bot.run
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end
    end

    context 'Successful validation of a yaml file' do
      it 'returns a zero exit code' do
        begin
          @cli_bot.run
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end

      it 'closes the log file after a successful run' do
        @cli_bot.run

        expect(@cli_bot.logger_bot.log_file.closed?).to be true
      end
    end

    context 'Failed validation of a yaml file' do
      before :each do
        path = '/../fixtures/invalid_yaml_bot_file_missing_required_key1.yml'
        bad_yaml_file = File.dirname(File.realpath(__FILE__)) + path
        @opts[:file] = bad_yaml_file
      end

      it 'returns a non-zero exit code' do
        expect(@cli_bot.run).to eq(1)
      end

      it 'closes the log file after a non-successful run' do
        @cli_bot.run

        expect(@cli_bot.logger_bot.log_file.closed?).to be true
      end
    end
  end
end
