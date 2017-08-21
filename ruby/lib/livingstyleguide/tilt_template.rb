require "tilt"
require "erb"
require "yaml"
require "json"

module LivingStyleGuide
  class TiltTemplate < ::Tilt::Template
    self.default_mime_type = "text/html"

    def prepare
    end

    def evaluate(scope, _)
      @scope = scope
      parse_options(data)
      render_living_style_guide
    end

    private

    def sass_options
      if defined?(Compass)
        options = Compass.configuration.to_sass_plugin_options
      else
        load_path = File.join(File.dirname(__FILE__), "..", "..", "stylesheets")
        options = { load_paths: [load_path] }
      end
      if defined?(Rails)
        options[:load_paths] += Rails.application.config.assets.paths
      end
      if @file.nil?
        options[:load_paths] << Dir.pwd
      end
      if options[:template_location]
        options[:template_location].each do |path, short|
          options[:load_paths] << path
        end
      end
      options[:filename]  = eval_file
      options[:line]      = line
      options[:syntax]    = @options[:syntax]
      options[:sprockets] = { context: @scope }
      options[:custom]    = { sprockets_context: @scope }
      if defined?(Sass::Rails::Resolver)
        options[:custom][:resolver] = Sass::Rails::Resolver.new(@scope)
      end
      options
    end

    def parse_options(data)
      data.strip!
      @options = data[0] == "{" ? JSON.parse(data) : YAML.load(data)
      @options = {} unless @options
      @options.keys.each do |key|
        @options[key.tr("-", "_").to_sym] = @options.delete(key)
      end
      @options[:syntax] = @options.has_key?(:styleguide_sass) ? :sass : :scss
      @options[:source] ||= File.basename(file, ".html.lsg")
      @options[:filename] = file
      @options[:root] ||= root
    end

    def configure_cache
      return unless @scope.respond_to?(:depend_on)
      @engine.files.uniq.each do |file|
        @scope.depend_on file
      end
    end

    def root
      if @scope.respond_to?(:environment) &&
         @scope.environment.respond_to?(:root)
        @scope.environment.root
      else
        find_root_path
      end
    end

    def find_root_path
      path = @file.nil? ? Dir.pwd : File.dirname(@file)
      while !path.empty?
        if File.exists?(File.join(path, "Gemfile")) ||
           File.exists?(File.join(path, ".git"))
          break
        end
        path = File.expand_path("..", path)
        if path == "/"
          break
        end
      end
      path
    end

    def render_living_style_guide
      @engine = ::LivingStyleGuide::Engine.new(@options, sass_options)
      html = @engine.render
      configure_cache
      html
    end
  end
end
