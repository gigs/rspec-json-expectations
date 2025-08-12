# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/json_expectations/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-json-expectations"
  spec.version       = RSpec::JsonExpectations::VERSION
  spec.authors       = ["Gigs Engineering"]
  spec.license       = "MIT"
  spec.summary       = "RSpec matchers for working with JSON."

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.6"
  spec.add_development_dependency "rake"
end
