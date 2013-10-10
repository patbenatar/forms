# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forms/version'

Gem::Specification.new do |spec|
  spec.name          = "forms"
  spec.version       = Forms::VERSION
  spec.authors       = ["patbenatar"]
  spec.email         = ["nick@gophilosophie.com"]
  spec.description   = "Separate your forms and models once and for all!"
  spec.summary       = "Separate your forms and models once and for all!"
  spec.homepage      = "http://github.com/patbenatar/forms"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features|example)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 2.14.0"
  spec.add_development_dependency "guard-rspec", "~> 3.1.0"
  spec.add_development_dependency "rb-fsevent", "~> 0.9.3"
  spec.add_development_dependency "awesome_print", "~> 1.2.0"
  spec.add_development_dependency "nokogiri", "~> 1.6.0"

  spec.add_dependency "activesupport", "> 3.0"
  spec.add_dependency "i18n", "~> 0.6.5"
end
