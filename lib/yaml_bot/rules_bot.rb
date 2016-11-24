require 'yaml'
require 'yaml_bot/logging'
require 'yaml_bot/validation_error'

module YamlBot
  class RulesBot
    def self.scan(rules)
      @rules = rules
      if @rules['root_keys']['required'].nil?
        missing_required_keys = true
        YamlBot::Logging.info 'No required keys specified.'
      end
      if @rules['root_keys']['optional'].nil?
        missing_optional_keys = true
        YamlBot::Logging.info 'No optional keys specified.'
      end

      if missing_required_keys && missing_optional_keys
        msg = 'Missing both required and optional root keys.\n'
        msg += 'Rules file must include at least one of those keys.\n'
        raise YamlBot::ValidationError.new(msg)
      end
    end
  end
end
