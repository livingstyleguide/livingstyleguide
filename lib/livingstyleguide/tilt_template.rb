require 'tilt'
require 'erb'
require 'compass'

module ::Tilt
  class LivingStyleGuideTemplate < Template
    self.default_mime_type = 'text/html'

    def prepare
    end

    def evaluate(scope, locals, &block)
      engine = ::Sass::Engine.new(data, sass_options)
      @output ||= engine.render_living_style_guide
    end

    private
    def sass_options
      options = Compass.configuration.to_sass_plugin_options
      options[:template_location].each do |path, short|
        options[:load_paths] << path
      end
      options[:filename]   = eval_file
      options[:line]       = line
      options[:syntax]     = @file =~ /\.sass/ ? :sass : :scss
      options[:importer]   = LivingStyleGuide::Importer.instance
      options
    end
  end

  %w(sass.lsg scss.lsg).each do |ext|
    register ext, LivingStyleGuideTemplate
  end
end

