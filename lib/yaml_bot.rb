require "yaml_bot/version"
require 'yaml_bot/yaml_bot'

module YamlBot
  @@violations = 0
  # Your code goes here...

  def self.get_violations
    @@violations
  end

  def self.violation
    @@violations += 1
  end
end
