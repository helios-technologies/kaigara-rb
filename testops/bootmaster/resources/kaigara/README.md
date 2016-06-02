# Kaigara

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

## Usage

Basic commands are
```
# Prepare ruby runtime on a remote host
$> kaish remote bootstrap USER@SERVER

# Creates a system operation package (sysops)
$> kaish sysops create NAME

# Generate an operation. Creates an empty file in folder operations
$> kaish sysops generate NAME

# Execute all operations of the current working directory
$> kaish sysops exec [DIRECTORY]

# Install a kaigara sysops package from github or a private git repository
$> kaish sysops install USER/NAME

# list all kaigara sysops package located in ~/.kaigara/sysops
$> kaish sysops list
```

You can use `kaish help` any time to get help.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/helios-technologies/kaigara.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
