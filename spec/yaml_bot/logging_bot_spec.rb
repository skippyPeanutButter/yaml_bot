require 'spec_helper'
require 'yaml_bot/logging_bot'
require 'stringio'

ESCAPES = { green: "\033[32m",
            yellow: "\033[33m",
            red: "\033[31m",
            reset: "\033[0m" }.freeze

describe YamlBot::LoggingBot do
  before :each do
    @log_file = StringIO.new
    @logger = YamlBot::LoggingBot.new(@log_file)
  end

  it 'has a log level of info by default' do
    expect(@logger.log_level).to eq(:info)
  end

  describe '#info' do
    it 'prefixes each log line with INFO:' do
      @logger.info('Test line 1')
      @logger.info('Testline2')
      expected_string = "INFO: Test line 1\n"
      expected_string += "INFO: Testline2\n"

      expect(@log_file.string).to eq(expected_string)
    end

    it 'outputs a message in green to stdout' do
      msg = 'This is a test'
      expected_string = ESCAPES[:green] + msg + ESCAPES[:reset] + "\n"

      expect { @logger.info(msg) }.to output(expected_string).to_stdout
    end
  end

  describe '#warn' do
    it 'prefixes each log line with WARN:' do
      @logger.warn('Test line 1')
      @logger.warn('Testline2')
      expected_string = "WARN: Test line 1\n"
      expected_string += "WARN: Testline2\n"

      expect(@log_file.string).to eq(expected_string)
    end

    it 'outputs a message in yellow to stdout' do
      msg = 'This is a test'
      expected_string = ESCAPES[:yellow] + msg + ESCAPES[:reset] + "\n"

      expect { @logger.warn(msg) }.to output(expected_string).to_stdout
    end
  end

  describe '#error' do
    it 'prefixes each log line with ERROR:' do
      @logger.error('Test line 1')
      @logger.error('Testline2')
      expected_string = "ERROR: Test line 1\n"
      expected_string += "ERROR: Testline2\n"

      expect(@log_file.string).to eq(expected_string)
    end

    it 'outputs a message in red to stdout' do
      msg = 'This is a test'
      expected_string = ESCAPES[:red] + msg + ESCAPES[:reset] + "\n"

      expect { @logger.error(msg) }.to output(expected_string).to_stdout
    end
  end

  describe '#close_log' do
    it 'closes the stream of the log file' do
      @logger.close_log

      expect(@log_file.closed?).to be true
    end
  end
end
