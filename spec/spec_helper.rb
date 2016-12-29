$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'yaml_bot'
require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  # Only allow expect syntax within specs
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
