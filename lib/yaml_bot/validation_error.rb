module YamlBot
  # ValidationError denotes errors detected when validating
  # yamlbot rules files against the RULES_DEFINITION.md specification.
  class ValidationError < StandardError
    def initialize(msg)
      super(msg)
    end
  end
end
