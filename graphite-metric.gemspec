# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "graphite-metric/version"

Gem::Specification.new do |s|
  s.name        = "graphite-metric"
  s.version     = GraphiteMetric::VERSION
  s.authors     = ["Gerhard Lazu"]
  s.email       = ["gerhard@lazu.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Generates strings that graphite understands}
  s.description = %q{Converts hashes and arrays into graphite plaintext format}

  #s.rubyforge_project = "graphite-metric"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'turn'
end
