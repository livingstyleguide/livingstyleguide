require 'erb'
require 'ostruct'
require 'compass'

module LivingStyleGuide
  class VariablesImporter < Sass::Importers::Base
    VALID_FILE_NAME = /\A#{Sass::SCSS::RX::IDENT}\Z/
    VARIABLE_IMPORTER_STRING = 'LivingStyleGuide::VariablesImporter'
    VALID_EXTENSIONS = %w(*.sass *.scss)

    TEMPLATE_FOLDER = File.join(File.expand_path('../', __FILE__), 'variables_importer')
    CONTENT_TEMPLATE_FILE = File.join(TEMPLATE_FOLDER, 'content.erb')
    CONTENT_TEMPLATE = ERB.new(File.read(CONTENT_TEMPLATE_FILE))

    def find(uri, options)
      if uri =~ /^#{VARIABLE_IMPORTER_STRING}$/
        @options = options
        return self.class.sass_engine(uri, all_variables, self, options)
      end
      nil
    end

    def root
    end

    def find_relative(uri, base, options)
      nil
    end

    def to_s
      self.class.name
    end

    def hash
      self.class.name.hash
    end

    def eql?(other)
      other.class == self.class
    end

    def key(uri, options={})
      [self.class.name + ":variables:" + File.dirname(File.expand_path(uri)), File.basename(uri)]
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

    def all_variables
      variables = []
      test = /^#{File.dirname(@options[:filename])}/
      @options[:living_style_guide].files.each do |file|
        if file =~ test
          sass = File.read(file)
          variables << sass.scan(%r(\$([a-z\-_]+)\s*:))
        end
      end
      variables.flatten!
      variables.uniq!
      variables
    end

    def self.sass_options(uri, importer, options)
      options.merge! :filename => uri.gsub(%r{\*/},"*\\/"), :syntax => :scss, :importer => importer
    end

    def self.sass_engine(uri, name, importer, options)
      content = content_for_images(uri, name, options[:skip_overrides])
      Sass::Engine.new(content, sass_options(uri, importer, options))
    end

    def self.content_for_images(uri, variables, skip_overrides = false)
      binder = LivingStyleGuide::Binding.new(:variables => variables)
      CONTENT_TEMPLATE.result(binder.get_binding)
    end
  end

  class Binding < OpenStruct
    def get_binding
      binding
    end
  end
end
