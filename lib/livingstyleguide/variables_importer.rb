require 'erb'
require 'ostruct'
require 'compass'

module LivingStyleGuide
  class VariablesImporter < Sass::Importers::Base
    VARIABLE_IMPORTER_STRING = 'LivingStyleGuide::VariablesImporter'
    TEMPLATE_FOLDER = File.join(File.dirname(__FILE__), 'templates')
    CONTENT_TEMPLATE_FILE = File.join(TEMPLATE_FOLDER, 'variables.scss.erb')
    CONTENT_TEMPLATE = ERB.new(File.read(CONTENT_TEMPLATE_FILE))

    def find(uri, options)
      if uri =~ /^#{VARIABLE_IMPORTER_STRING}$/
        variables = options[:living_style_guide].variables
        binder = LivingStyleGuide::Binding.new(:variables => variables)
        scss = CONTENT_TEMPLATE.result(binder.get_binding)
        return ::Sass::Engine.new(scss, syntax: :scss)
      end
      nil
    end

    def find_relative(uri, base, options)
      nil
    end

    def to_s
      self.class.name
    end

    def self.variables(uri)
      uri = uri.dup
      uri += '.s?ss' unless uri =~ /\.s[ac]ss$/
      uri.gsub! %r{^(.*)/(.+)$}, '\1/{_,}\2'
      variables = []
      paths = [Compass.configuration.sass_path, Compass.configuration.additional_import_paths].flatten
      paths.each do |path|
        if path.is_a? String
          Dir.glob(File.join(path, uri)).each do |file|
            sass = File.read(file)
            variables << sass.scan(%r(\$([a-z0-9\-_]+)\s*:))
          end
        end
      end
      variables.flatten!
      variables.uniq!
      variables
    end

  end

  class Binding < OpenStruct
    def get_binding
      binding
    end
  end
end

