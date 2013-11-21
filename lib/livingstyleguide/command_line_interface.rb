require 'rubygems'
require 'bundler/setup'
require 'thor'
require 'tilt'

module LivingStyleGuide
  class CommandLineInterface < Thor

    desc 'compile filename', 'Compiles the living style guide to HTML.'
    def compile(file)
      Compass.add_project_configuration
      html = Tilt.new(file).render
      puts html
    end

  end
end

