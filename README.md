[![Build Status](https://travis-ci.org/skippyPeanutButter/yaml_bot.svg?branch=master)](https://travis-ci.org/skippyPeanutButter/yaml_bot)
[![Code Climate](https://codeclimate.com/github/skippyPeanutButter/yaml_bot/badges/gpa.svg)](https://codeclimate.com/github/skippyPeanutButter/yaml_bot)
[![Test Coverage](https://codeclimate.com/github/skippyPeanutButter/yaml_bot/badges/coverage.svg)](https://codeclimate.com/github/skippyPeanutButter/yaml_bot/coverage)

# YamlBot

YamlBot is not a Yaml linter, it is a Yaml format validator.


### Why

Mistakes can often be made when working with yaml-based configuration. Systems
such as travis-ci, rubocop, and other tools that utilize yaml files to govern
how they work often present users with a multitude of keys that can take on
many possible values. `yamlbot` allows you to feed it a set of rules that a
yaml-based system follows and then validate any yaml file against those rules.

If you have a tool that works off of a yaml configuration then you can craft
your own [`.yamlbot.yml` file][yamlbot-spec], share it with others, and have
them use `yamlbot` to validate their config against your specified rules.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'yaml_bot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaml_bot

### Usage

Create a `.yamlbot.yml` file with a set of rules that you want to validate yaml
files against [yamlbot file specification](RULES_DEFINITION.md).

Usage assuming the existence `.yamlbot.yml` in the current directory:

```bash
yamlbot -f yaml_file_to_validate
```

Usage passing the path to a rules file
(doesn't have to be named `.yamlbot.yml`):

```bash
yamlbot -f yaml_file_to_validate [-r path_to_rules_file]
```

```bash
Usage: yamlbot -f yaml_file_to_validate [-r path_to_rules_file]
        -r, --rule-file rules           The rules you will be evaluating your yaml against
        -f, --file file                 The file to validate against
        -h, --help                      help
```

### Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

### Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/skippyPeanutButter/yaml_bot. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


### License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
