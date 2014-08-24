require 'erb'
require 'ostruct'
require 'compass'

module LivingStyleGuide
  class VariablesImporter < Sass::Importers::Base

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
end

