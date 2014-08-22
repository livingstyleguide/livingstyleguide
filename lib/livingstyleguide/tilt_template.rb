require 'tilt'
require 'erb'
require 'compass'
require 'yaml'
require 'json'

module ::Tilt
  class LivingStyleGuideTemplate < Template
    self.default_mime_type = 'text/html'

    def prepare
    end

    def evaluate(scope, locals, &block)
      @scope = scope
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
        options[:load_paths] << path
      end
      options[:filename]  = eval_file
      options[:line]      = line
      options[:syntax]    = @options[:syntax]
      options[:sprockets] = { context: @scope }
      options[:custom]    = { sprockets_context: @scope }
      options
    end

    private
    def parse_options(data)
      data.strip!
      @options = (data[0] == '{') ? JSON.parse(data) : YAML.load(data)
      @options = {} unless @options
      @options.keys.each do |key|
        @options[key.gsub('-', '_').to_sym] = @options.delete(key)
      end
      @options[:syntax] = @options.has_key?(:styleguide_sass) ? :sass : :scss
      @options[:source] ||= File.basename(file, '.html.lsg')
      @options[:filename] = file
      @options[:root] ||= root
    end

    private
    def generate_sass
      @sass = [
        %Q(@import "#{@options[:source]}"),
        style_variables,
        %Q(@import "livingstyleguide"),
        #%Q(@import "#{::LivingStyleGuide::VariablesImporter::VARIABLE_IMPORTER_STRING}"),
        @options[:styleguide_sass] || @options[:styleguide_scss]
      ].flatten.join(@options[:syntax] == :sass ? "\n" : ';')
    end

    private
    def configure_cache
      return unless @scope.respond_to?(:depend_on)
      test = /^#{File.expand_path(root)}\//
      @engine.files.uniq.each do |file|
        if File.expand_path(file) =~ test
          @scope.depend_on $'
        end
      end
    end

    private
    def root
      if @scope.respond_to?(:environment)
        @scope.environment.root
      else
        find_root_path
      end
    end

    private
    def find_root_path
      path = File.dirname(@file)
      while path.length > 0 do
        if File.exists?(File.join(path, 'Gemfile')) or File.exists?(File.join(path, '.git'))
          break
        end
        path = File.expand_path('..', path)
      end
      path
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
      @engine = ::LivingStyleGuide::Engine.new(@sass, @options, sass_options)
      html = @engine.render
      configure_cache
      html
    end
  end

  register 'lsg', LivingStyleGuideTemplate
end

