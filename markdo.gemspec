# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'markdo/version'

Gem::Specification.new do |spec|
  spec.name          = "markdo"
  spec.version       = Markdo::VERSION
  spec.authors       = ["Benjamin Oakes"]
  spec.email         = ["hello@benjaminoakes.com"]
  spec.description   = %q{Markdown-based task manager}
  spec.summary       = %q{Markdown-based task manager}
  spec.homepage      = "http://github.com/benjaminoakes/markdo"
  spec.license       = "MIT"

  spec.files         = File.directory?('.git') ? `git ls-files`.split($/) : []
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rake"
  spec.add_development_dependency "opal"
  spec.add_development_dependency "opal-jquery"
  spec.add_development_dependency "opal-rspec"
  spec.add_development_dependency "uglifier"
end
