# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kaigara/version'

Gem::Specification.new do |spec|
  spec.name          = "kaigara"
  spec.version       = Kaigara::VERSION
  spec.authors       = ["Helios Technologies"]
  spec.email         = ["contact@heliostech.fr"]

  spec.summary       = %q{Kaigara is a swiss army knife for Devops}
  spec.description   = %q{Kaigara is an extensible shell command line for managing simple system operations.}
  spec.homepage      = "https://github.com/helios-technologies/kaigara"
  spec.license       = "MIT"

  spec.executables   = ["kaish","console","setup"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.19.1"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
end
