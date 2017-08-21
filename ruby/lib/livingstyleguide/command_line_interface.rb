require "thor"
require "tilt"

module LivingStyleGuide
  class CommandLineInterface < Thor
    desc "compile input_file output_file",
         "Compiles the living style guide to HTML."
    def compile(input_file = nil, output_file = nil)
      doc = LivingStyleGuide::Document.new(input_file) do
        input(input_file)
      end
      output doc.render, input_file, output_file
    end

    desc "version",
         "Shows the current version of the Gem"
    def version
      puts "LivingStyleGuide #{LivingStyleGuide::VERSION}"
    end

    private

    def input(input_file = nil)
      @input ||= if input_file.nil?
                   $stdin.read
                 else
                   File.read(input_file)
                 end
    end

    def output(html, input_file = nil, output_file = nil)
      if input_file.nil?
        puts html
      else
        if output_file.nil?
          output_file = input_file.sub(/(\.html)?\.lsg$/, ".html")
        end
        if defined?(Compass)
          Compass.add_project_configuration
          output_file = output_file.sub(/^#{Compass.configuration.sass_dir}/,
                                        Compass.configuration.css_dir)
        end
        File.write output_file, html
        puts "Successfully generated a living style guide at #{output_file}."
      end
    end
  end
end
