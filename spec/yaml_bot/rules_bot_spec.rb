require 'spec_helper'
require 'yaml'
require 'yaml_bot/validation_error'
require 'stringio'

describe YamlBot::RulesBot do
  describe '#validate_rules' do
    context 'successful validation' do
      it 'should not raise an error when a rules file is successfully validated'
    end

    context 'failed validation' do
      it 'should raise a RulesFileValidationError when a rules file is missing the rules key'
      it 'should raise a RulesFileValidationError when a set of rules contains an unapproved key'
      it 'should raise a RulesFileValidationError when a set of rules is missing a key to validate'
    end
  end
end
