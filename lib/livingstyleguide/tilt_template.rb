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
      engine.render_living_style_guide
    end

    private
    def sass_options
      options = Compass.configuration.to_sass_plugin_options
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
  end

  register 'lsg', LivingStyleGuideTemplate
end

