require 'spec_helper'
require 'yaml'

describe YamlBot::ValidationBot do
  before :each do
    @yaml_bot = YamlBot::ValidationBot.new
  end

  it 'is initialized with 0 violations' do
    expect(@yaml_bot.violations).to eq(0)
  end

  describe '#scan' do
    context 'yaml file successfully validated against specified rules' do
      it 'should return 0 violations' do
      end
    end

    context 'yaml file not successfully validated against specified rules' do
      it 'should return the number of violations in the yaml file' do
        @yaml_bot.rules = YAML.load_file(File.dirname(File.realpath(__FILE__)) +
                                         '/../fixtures/valid_rules.yml')
        {
          '/../fixtures/validation_test1.yml' => 1,
          '/../fixtures/validation_test2.yml' => 2,
          '/../fixtures/validation_test3.yml' => 3,
          '/../fixtures/validation_test4.yml' => 4,
          '/../fixtures/validation_test5.yml' => 5
        }.each do |yaml_file, num_of_violations|
          yaml = File.dirname(File.realpath(__FILE__)) + yaml_file
          @yaml_bot.yaml_file = YAML.load_file(yaml)
          expect(@yaml_bot.scan).to eq(num_of_violations)
          @yaml_bot.violations = 0
        end
      end
    end
  end

  after :each do
    @yaml_bot = nil
  end
end
