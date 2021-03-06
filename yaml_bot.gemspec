lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_bot/version'

Gem::Specification.new do |spec|
  spec.name          = 'yaml_bot'
  spec.version       = YamlBot::VERSION
  spec.authors       = ['Luis Ortiz']
  spec.email         = ['lortiz1145@gmail.com']

  spec.summary       = 'Validate YAML files according to a set of rules.'
  spec.homepage      = 'https://github.com/skippyPeanutButter/yaml_bot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.5.0'
  spec.add_development_dependency 'rspec', '~> 3.7.0'
  spec.add_development_dependency 'rubocop', '~> 0.54.0'

  spec.required_ruby_version = '>=2.4'
end
