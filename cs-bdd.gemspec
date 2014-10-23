# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cs/bdd/version'

Gem::Specification.new do |spec|
  spec.name          = "cs-bdd"
  spec.version       = CS::BDD::VERSION
  spec.authors       = ["CSOscarTanner"]
  spec.email         = ["oscar.tanner@concretesolutions.com.br"]
  spec.summary       = %q{Generates an android and iOS calabash project.}
  spec.description   = %q{A simple gem to generate all the folder and files needed to create an android and iOS calabash project.}
  spec.homepage      = "http://www.concretesolutions.com.br"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end