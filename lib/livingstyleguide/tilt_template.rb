require 'tilt'
require 'erb'
require 'compass'
require 'yaml'

module ::Tilt
  class LivingStyleGuideTemplate < Template
    self.default_mime_type = 'text/html'

    def prepare
    end

    def evaluate(scope, locals, &block)
      parse_options(data)
      generate_sass
      render_living_style_guide
    end

    private
    def sass_options
      options = Compass.configuration.to_sass_plugin_options
      if defined?(Rails)
        options[:load_paths] = options[:load_paths] | Rails.application.config.assets.paths
      end
      options[:template_location].each do |path, short|
        options[:load_paths] << ::LivingStyleGuide::Importer.new(path)
      end
      options[:filename]           = eval_file
      options[:line]               = line
      options[:syntax]             = @options[:syntax]
      options[:importer]           = LivingStyleGuide::Importer.new('.')
      options[:living_style_guide] = @options
      options
    end

    private
    def parse_options(data)
      @options = YAML.load(data)
      @options.keys.each do |key|
        @options[key.gsub('-', '_').to_sym] = @options.delete(key)
      end
      @options[:syntax] = @options.has_key?(:additional_sass) ? :sass : :scss
    end

    private
    def generate_sass
      @sass = [
        %Q(@import "#{@options[:source]}"),
        style_variables,
        %Q(@import "livingstyleguide"),
        @options[:additional_sass] || @options[:additional_scss]
      ].flatten.join(@options[:syntax] == :sass ? "\n" : ';')
    end

    private
    def style_variables
      return unless @options.has_key?(:style)
      @options[:style].map do |key, value|
        "$livingstyleguide--#{key}: #{value}"
      end
    end

    private
    def render_living_style_guide
      engine = ::Sass::Engine.new(@sass, sass_options)
      engine.render_living_style_guide
    end
  end

  register 'lsg', LivingStyleGuideTemplate
end

