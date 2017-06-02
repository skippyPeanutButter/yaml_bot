require 'yaml'
require 'yaml_bot/rules_bot'
require 'yaml_bot/validation_bot'

module YamlBot
  class CLIBot
    attr_accessor :options, :logger_bot, :rules_bot, :validation_bot

    def initialize(opts = {})
      @options = opts
      @rules_bot = RulesBot.new
      @validation_bot = ValidationBot.new
    end

    def run
      check_cli_options
      load_rules
      load_yaml
      scan_yaml
      print_results
      @validation_bot.violations.zero? ? 0 : 1
    end

    private

    def print_results
      if @validation_bot.violations.positive?
        puts pluralize(@validation_bot.violations,
                       'violation',
                       'violations')
      else
        puts "#{@validation_bot.violations} violations"
      end
    end

    def load_rules
      rules_file = @options[:rules] || '.yamlbot.yml'
      raise FileNotFoundError unless File.exist?(rules_file)
      rules = YAML.load_file(rules_file)
      @rules_bot.rules = rules
      @validation_bot.rules = rules
    rescue FileNotFoundError
      $stderr.puts "Unable to locate file: #{rules_file}"
      $stderr.puts 'Create a .yamlbot.yml file in the current directory'
      $stderr.puts 'or specify a rules file with the -r option'
      exit 1
    end

    def load_yaml
      raise StandardError, 'No YAML file specified' if @options[:file].nil?
      raise FileNotFoundError unless File.exist?(@options[:file])
      @validation_bot.yaml_file = YAML.load_file(@options[:file])
    rescue FileNotFoundError
      $stderr.puts "Unable to locate file: #{@options[:file]}"
      $stderr.puts 'Pass a YAML file to validate with the -f option'
      exit 1
    end

    def scan_yaml
      puts 'Beginning scan...'
      @validation_bot.scan
      puts 'Finished scan...'
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
        "\t-c, --color\t\t\tEnable colored output",
        "\t-h, --help\t\t\thelp"
      ].join("\n")
      puts msg
    end
  end
end
