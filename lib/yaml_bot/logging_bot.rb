module YamlBot
  class LoggingBot
    class LoggingError < RuntimeError
      def initialize(msg)
        super(msg)
      end
    end

    ESCAPES = { green: "\033[32m",
                yellow: "\033[33m",
                red: "\033[31m",
                reset: "\033[0m" }.freeze
    LOGLEVEL = { info: [:info, :warn, :error],
                 warn: [:warn, :error],
                 error: [:error] }.freeze

    attr_accessor :log_file, :log_level

    def initialize(log_file, level: :info, no_color: false)
      @log_file = log_file
      @log_level = level.to_sym unless valid_log_level(level)
      @no_color = no_color
    end

    def info(message)
      log(message, :info)
      emit(message: message, color: :green)
    end

    def warn(message)
      log(message, :warn)
      emit(message: message, color: :yellow)
    end

    def error(message)
      log(message, :error)
      emit(message: message, color: :red)
    end

    def log(message, level)
      message = level.to_s.upcase + ': ' + message + "\n"
      log_file.write(message) if LOGLEVEL[log_level].include?(level)
    end

    def close_log
      log_file.close
    end

    private

    def emit(opts = {})
      color   = opts[:color]
      message = opts[:message]
      print ESCAPES[color] unless @no_color
      print message
      print ESCAPES[:reset] unless @no_color
      print "\n"
    end

    def valid_log_level(level)
      return if LOGLEVEL[:info].include?(level.to_sym)
      msg = 'Invalid loglevel specified.'
      msg += 'Loglevel must info, warn, or error.'
      raise LoggingError, msg
    end
  end
end
