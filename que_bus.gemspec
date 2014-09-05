# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'que_bus/version'

Gem::Specification.new do |spec|
  spec.name          = "que_bus"
  spec.version       = QueBus::VERSION
  spec.authors       = ["Andrew Swerlick"]
  spec.email         = ["andrew.swerlick@gmail.com"]
  spec.summary       = %q{An event bus based on the que queing framework}
  spec.description   = %q{An event bus based on the que queing framework}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end