# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'livingstyleguide/version'

Gem::Specification.new do |gem|
  gem.name          = "livingstyleguide"
  gem.version       = LivingStyleGuide::VERSION
  gem.authors       = ["Nico Hagenburger"]
  gem.email         = ["nico@hagenburger.net"]
  gem.description   = %q{Living Style Guide}
  gem.summary       = %q{Living Style Guide}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'minisyntax'
  gem.add_dependency 'compass'
  gem.add_dependency 'sass'
  gem.add_dependency 'redcarpet'
  gem.add_dependency 'tilt'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'thor'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'haml'
end
