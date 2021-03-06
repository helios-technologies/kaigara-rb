# Kaigara

! This was a prototype now implemented in go : [kaigara repo](http://github.com/mod/kaigara) and [Kaigara web](http://www.kaigara.org)

[![Build Status](https://travis-ci.org/helios-technologies/kaigara.svg?branch=master)](https://travis-ci.org/helios-technologies/kaigara) [![Gem Version](https://badge.fury.io/rb/kaigara.svg)](https://badge.fury.io/rb/kaigara)

Kaigara is an extendable shell command line for managing simple devops tasks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kaigara'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kaigara

On bare systems:
```
bash <(curl -s https://raw.githubusercontent.com/kaigara-sysops/vagrant-devbox/master/scripts/kairb.sh)
```
or
```
curl -s https://raw.githubusercontent.com/kaigara-sysops/vagrant-devbox/master/scripts/kairb.sh | bash -s
```

## Usage

Basic commands are
```
# Creates a system operation package (sysops)
$> kaish sysops create NAME

# Generate an operation. Creates an empty file in folder operations
$> kaish sysops generate NAME

# Execute all operations of the current working directory
$> kaish sysops exec [DIRECTORY]
```

You can use `kaish help` any time to get help.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/helios-technologies/kaigara.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
