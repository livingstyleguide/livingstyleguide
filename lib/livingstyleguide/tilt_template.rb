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
      options[:filename] = eval_file
      options[:line]     = line
      options[:syntax]   = detect_syntax
      options[:importer] = LivingStyleGuide::Importer.new('.')
      options
    end

    private
    def detect_syntax
      data =~ %r(^//\s*@syntax\s*:\s*sass\s*$) ? :sass : :scss
    end

    private
    def parse_options(data)
      @options = YAML.load(data)
      @options.keys.each do |key|
        @options[key.to_sym] = @options.delete(key)
      end
    end

    private
    def generate_sass
      @sass = <<-SCSS
        @import "#{@options[:source]}";
        @import "livingstyleguide";
      SCSS
    end

    private
    def render_living_style_guide
      engine = ::Sass::Engine.new(@sass, sass_options)
      engine.render_living_style_guide
    end
  end

  register 'lsg', LivingStyleGuideTemplate
end

