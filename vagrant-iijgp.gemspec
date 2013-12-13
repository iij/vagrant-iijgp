# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-iijgp/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-iijgp"
  spec.version       = VagrantPlugins::ProviderIijGp::VERSION
  spec.authors       = ["Takahiro HIMURA"]
  spec.email         = ["taka@himura.jp"]
  spec.description   = %q{Vagrant plugin for IIJ GIO Hosting Package service}
  spec.summary       = %q{Vagrant plugin for IIJ GIO Hosting Package service}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "iij-sakagura"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-core"
  spec.add_development_dependency "rspec-expectations"
  spec.add_development_dependency "mocha"
end
