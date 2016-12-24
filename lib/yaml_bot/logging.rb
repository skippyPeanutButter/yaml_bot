module YamlBot
  module Logging
    ESCAPES = { green: "\033[32m",
                yellow: "\033[33m",
                red: "\033[31m",
                reset: "\033[0m" }.freeze

    def self.info(message)
      emit(message: message, color: :green)
    end

    def self.warn(message)
      emit(message: message, color: :yellow)
    end

    def self.error(message)
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
  end
end
