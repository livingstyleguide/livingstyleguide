require 'rubygems'
begin
require 'bundler/setup'
rescue LoadError
end
require 'thor'
require 'tilt'

module LivingStyleGuide
  class CommandLineInterface < Thor

    desc 'compile input output', 'Compiles the living style guide to HTML.'
    option :stdin, type: :boolean
    option :stdout, type: :boolean
    def compile(input = nil, output = nil)
      unless input.nil?
        output = input.sub(/(\.html)?\.lsg$/, '.html') if output.nil?
        if defined?(Compass)
          Compass.add_project_configuration
          output = output.sub /^#{Compass.configuration.sass_dir}/, Compass.configuration.css_dir
        end
      end
      template = LivingStyleGuide::TiltTemplate.new(input) do
        if options[:stdin]
          $stdin.read
        else
          File.read(input)
        end
      end
      html = template.render
      if options[:stdout]
        puts html
      else
        File.write output, html
        puts "Successfully generated a living style guide at #{output}."
      end
    end

  end
end

