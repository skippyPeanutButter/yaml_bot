require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run rubocop'
task :rubocop do
  require 'rubocop'
  cli = RuboCop::CLI.new
  cli.run
end

task default: %i[rubocop spec]
