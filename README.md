[![Build Status](https://travis-ci.org/skippyPeanutButter/yaml_bot.svg?branch=master)](https://travis-ci.org/skippyPeanutButter/yaml_bot)

# YamlBot

YamlBot is not a Yaml linter, it is a Yaml format validator.


### Why

Specify custom rules for different Yaml files.  You should be able to feed
YamlBot a specification for how a Yaml file should look and then let it do the
rest.

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

Create or make use of a specification for what a particular yaml file should
contain (see [yamlbot file specification][yamlbot-spec].

```bash
Usage: yamlbot -f yaml_file_to_validate [-r path_to_rules_file]
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

[yamlbot-spec]: https://github.com/skippyPeanutButter/yaml_bot/wiki/Rules-file-specification
