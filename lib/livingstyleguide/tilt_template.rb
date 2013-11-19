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
      load_paths = [File.dirname(eval_file), LivingStyleGuide::Importer.instance]
      syntax     = @file[-5..-1].to_sym
      options.merge(:filename => eval_file, :line => line, :syntax => syntax, :load_paths => load_paths)
    end
  end

  %w(html.sass html.scss).each do |ext|
    register ext, LivingStyleGuideTemplate
  end
end

