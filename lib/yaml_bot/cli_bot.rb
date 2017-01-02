require 'yaml'
require 'yaml_bot/logging_bot'
require 'yaml_bot/rules_bot'
require 'yaml_bot/validation_bot'
require 'active_support/core_ext/hash/keys'

module YamlBot
  class CLIBot
    attr_accessor :options, :logger_bot, :rules_bot, :validation_bot

    def initialize(opts = {})
      @options = opts
      log_file = File.new('yaml_bot.log', 'w')
      @logger_bot = LoggingBot.new(log_file)
      @rules_bot = RulesBot.new
      @validation_bot = ValidationBot.new
    end

    def run
      check_cli_options
      load_rules_file
      load_yaml_file
      load_logger
      check_rules_file
      scan_yaml_file
      print_results
      @validation_bot.violations.zero? ? 0 : 1
    ensure
      @logger_bot.close_log
    end

    private

    def load_rules_file
      if @options[:rules].nil?
        load_default_rules
      else
        load_custom_rules
      end
    end

    def load_yaml_file
      yaml_file = YAML.load(File.open(@options[:file])).deep_symbolize_keys
      @validation_bot.yaml_file = yaml_file
    rescue StandardError => e
      puts "Unable to locate yaml file #{@options[:file]}..."
      puts e.message
      puts e.backtrace.inspect
      exit 1
    end

    def load_logger
      @rules_bot.logger = @logger_bot
      @validation_bot.logger = @logger_bot
    end

    def check_rules_file
      @rules_bot.validate_rules
    end

    def scan_yaml_file
      @logger_bot.info 'Beginning scan...'
      @validation_bot.scan
      @logger_bot.info 'Finished scanning...'
    end

    def print_results
      if @validation_bot.violations > 0
        @logger_bot.error pluralize(@validation_bot.violations,
                                    'violation',
                                    'violations')
      else
        @logger_bot.info "#{@validation_bot.violations} violations"
      end
      puts "Results logged to #{File.absolute_path(@logger_bot.log_file.path)}"
    end

    def load_default_rules
      rules_file = YAML.load(File.open('.yamlbot.yml')).deep_symbolize_keys
      @rules_bot.rules = rules_file
      @validation_bot.rules = rules_file
    rescue StandardError
      $stderr.puts 'Unable to locate .yamlbot.yml file...'
      $stderr.puts 'Create a .yamlbot.yml file in the current directory'
      $stderr.puts 'or specify a rules file with the -r option.'
      exit 1
    end

    def load_custom_rules
      rules_file = YAML.load(File.open(@options[:rules])).deep_symbolize_keys
      @rules_bot.rules = rules_file
      @validation_bot.rules = rules_file
    rescue StandardError => e
      $stderr.puts "Unable to locate rules file #{options[:rules]}..."
      $stderr.puts e.message
      $stderr.puts e.backtrace.inspect
      exit 1
    end

    def pluralize(n, singular, plural = nil)
      if n == 1
        "1 #{singular}"
      elsif plural
        "#{n} #{plural}"
      else
        "#{n} #{singular}s"
      end
    end

    def check_cli_options
      return unless @options.empty?
      print_help
      exit 1
    end

    def print_help
      msg = [
        'Usage: yamlbot -f yaml_file_to_validate [-r path_to_rules_file]',
        "\t-r, --rule-file rules\t\tThe rules you will be evaluating your "\
        'yaml against',
        "\t-f, --file file\t\t\tThe file to validate against",
        "\t-h, --help\t\t\thelp"
      ].join("\n")
      puts msg
    end
  end
end
