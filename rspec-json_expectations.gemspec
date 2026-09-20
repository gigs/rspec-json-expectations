# frozen_string_literal: true

require_relative "lib/rspec/json_expectations/version"

Gem::Specification.new do |spec|
  spec.name = "rspec-json-expectations"
  spec.version = RSpec::JsonExpectations::VERSION
  spec.authors = ["Gigs Engineering"]
  spec.license = "MIT"

  spec.summary = "RSpec matchers for working with JSON."
  spec.description = "Matchers and helpers for testing JSON API responses. " \
                     "Forked from waterlink/rspec-json_expectations."
  spec.homepage = "https://github.com/gigs/rspec-json-expectations"

  spec.required_ruby_version = ">= 3.4"

  spec.metadata = {
    "source_code_uri" => spec.homepage,
    "bug_tracker_uri" => "#{spec.homepage}/issues"
  }

  spec.files = Dir["lib/**/*.rb"] + ["LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec-core", ">= 3.0"
  spec.add_dependency "rspec-expectations", ">= 3.0"
end
