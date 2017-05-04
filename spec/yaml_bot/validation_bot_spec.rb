require 'spec_helper'
require 'active_support/core_ext/hash/keys'
require 'stringio'

describe YamlBot::ValidationBot do
  before :each do
    @yaml_bot = YamlBot::ValidationBot.new
    @yaml_bot.logger = YamlBot::LoggingBot.new(StringIO.new, no_color: true)
  end

  it 'is initialized with 0 violations' do
    expect(@yaml_bot.violations).to eq(0)
  end

  describe '#scan' do
  end
end
