# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque-latency/version'

Gem::Specification.new do |gem|
  gem.name          = "resque-latency"
  gem.version       = Resque::Latency::VERSION
  gem.authors       = ["Spike Grobstein"]
  gem.email         = ["me@spike.cx"]
  gem.description   = %q{Add a latency metric to queues}
  gem.summary       = %q{Add a latency metric to queues}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'resque', '~> 1.23.0'
end
