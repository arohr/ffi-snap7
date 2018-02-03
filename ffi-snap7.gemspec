# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ffi-snap7/version'

Gem::Specification.new do |spec|
  spec.name          = 'ffi-snap7'
  spec.version       = Snap7::VERSION
  spec.authors       = ['Andy Rohr']
  spec.email         = ['andy.rohr@mindclue.ch']
  spec.summary       = %q{FFI Ruby wrapper for Snap7 (http://snap7.sourceforge.net/)}
  spec.description   = %q{Access to Siemens PLCs, Simulation of Siemens PLCs}
  spec.homepage      = 'https://github.com/arohr/ffi-snap7'
  spec.license       = 'LGPLv3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ffi'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "minitest" # for assertions
  spec.add_development_dependency "guard-rspec"
end
