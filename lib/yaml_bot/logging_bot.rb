module YamlBot
  class LoggingBot
    ESCAPES = { green: "\033[32m",
                yellow: "\033[33m",
                red: "\033[31m",
                reset: "\033[0m" }.freeze

    @@log_file = File.new('yaml_bot.log', 'w')

    def self.info(message)
      @@log_file.write(message + "\n")
      emit(message: message, color: :green)
    end

    def self.warn(message)
      @@log_file.write(message + "\n")
      emit(message: message, color: :yellow)
    end

    def self.error(message)
      @@log_file.write(message + "\n")
      emit(message: message, color: :red)
    end

    def self.emit(opts = {})
      color   = opts[:color]
      message = opts[:message]
      print ESCAPES[color]
      print message
      print ESCAPES[:reset]
      print "\n"
    end

    def self.close_log
      @@log_file.close
    end
  end
end
