require 'spec_helper'

describe YamlBot::CLIBot do
  before :each do
    @logger_bot = YamlBot::LoggingBot.new(StringIO)
    @rules_bot = YamlBot::RulesBot.new
    @validation_bot = YamlBot::ValidationBot.new
    @cli_bot = YamlBot::CLIBot.new
  end

  it 'initializes a logger, a RulesBot object, and a ValidationBot object' do
    expect(@cli_bot.logger_bot).to_not be nil
    expect(@cli_bot.validation_bot).to_not be nil
    expect(@cli_bot.rules_bot).to_not be nil
  end

  describe '#load_rules_file' do
    it 'assigns a rules hash to a RulesBot object' do
      @cli_bot.rules_bot = @rules_bot
      @cli_bot.load_rules_file

      expect(@rules_bot.rules.instance_of?(Hash)).to be true
    end

    it 'assigns a rules hash to a ValidationBot object' do
      @cli_bot.validation_bot = @validation_bot
      @cli_bot.load_rules_file

      expect(@validation_bot.rules.instance_of?(Hash)).to be true
    end
  end

  describe '#load_logger' do
    before :each do
      @cli_bot.logger_bot = @logger_bot
    end

    it 'assigns a LoggerBot object to a RulesBot object' do
      @cli_bot.rules_bot = @rules_bot
      @cli_bot.load_logger

      expect(@rules_bot.logger.instance_of?(YamlBot::LoggingBot)).to be true
    end

    it 'assigns a LoggerBot object to a ValidationBot object' do
      @cli_bot.validation_bot = @validation_bot
      @cli_bot.load_logger

      expect(
        @validation_bot.logger.instance_of?(YamlBot::LoggingBot)
      ).to be true
    end
  end

  after :each do
    @logger_bot = nil
    @rules_bot = nil
    @validation_bot = nil
    @cli_bot = nil
  end
end
