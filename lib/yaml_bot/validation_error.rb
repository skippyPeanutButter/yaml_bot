module YamlBot
  class ValidationError < StandardError
    def initialize(msg)
      super(msg)
    end
  end
end
