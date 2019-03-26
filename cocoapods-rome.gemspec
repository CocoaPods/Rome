# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-rome/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = "cocoapods-rome"
  spec.version       = CocoapodsRome::VERSION
  spec.authors       = ["Boris Bügling"]
  spec.email         = ["boris@icculus.org"]
  spec.summary       = %q{Rome makes it easy to build a list of frameworks for consumption outside of
Xcode}
  spec.homepage      = "https://github.com/CocoaPods/Rome"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "cocoapods", ">= 1.1.0", "< 2.0"
  spec.add_dependency "fourflusher", "~> 2.2"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake"
end
