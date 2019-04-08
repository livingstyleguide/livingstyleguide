# -*- encoding: utf-8 -*-

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "livingstyleguide/version"

Gem::Specification.new do |gem|
  gem.name          = "livingstyleguide"
  gem.version       = LivingStyleGuide::VERSION
  gem.authors       = ["Nico Hagenburger"]
  gem.email         = ["nico@hagenburger.net"]
  gem.summary       = "Generate beautiful front-end style guides"
  gem.homepage      = "https://livingstyleguide.org"
  gem.description   = <<-DESCRIPTION.strip.gsub(/\s+/, " ")
    Automatically generate beautiful front-end style guides with Sass and
    Markdown. See https://livingstyleguide.org for details.
  DESCRIPTION

  gem.files = `git ls-files`.split($/).select do |f|
    f =~ /^(assets|bin|lib|stylesheets|templates)/
  end
  gem.executables = gem.files.grep(%r{^bin/}).map do |f|
    File.basename(f)
  end
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "minisyntax", ">= 0.2.5"
  gem.add_dependency "sassc"
  gem.add_dependency "redcarpet"
  gem.add_dependency "tilt"
  gem.add_dependency "thor"

  gem.add_development_dependency "compass"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "haml"
  gem.add_development_dependency "erubis"
  gem.add_development_dependency "heredoc_unindent", "~> 1.2.0"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "coffee-script"
  gem.add_development_dependency "i18n"
  gem.add_development_dependency "scss-lint"
  gem.add_development_dependency "rubocop"
end
