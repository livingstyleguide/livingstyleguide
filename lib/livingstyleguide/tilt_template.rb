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
      yaml, additional_sass = data.split("\n\n", 2)
      parse_options(yaml)
      generate_sass(additional_sass)
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
        @options[key.to_sym] = @options.delete(key)
      end
      @options[:syntax] = @options[:syntax] == 'sass' ? :sass : :scss
    end

    private
    def generate_sass(additional_sass)
      @sass = [
        %Q(@import "#{@options[:source]}"),
        %Q(@import "livingstyleguide"),
        additional_sass
      ].join(@options[:syntax] == :sass ? "\n" : ';')
    end

    private
    def render_living_style_guide
      engine = ::Sass::Engine.new(@sass, sass_options)
      engine.render_living_style_guide
    end
  end

  register 'lsg', LivingStyleGuideTemplate
end

