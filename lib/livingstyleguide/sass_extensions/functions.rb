module LivingStyleGuide::SassExtensions::Functions

  def list_variables(uri)
    Sass::Util.sass_warn '`list-variables()` is depricated and will be removed in v2.0.0.'
    uri = uri.value
    variables = parse_variables(uri)
    variables.map! do |name|
      Sass::Script::String.new(name)
    end
    Sass::Script::List.new(variables, :space)
  end

  def global_variables
    ruby = environment.global_env.instance_variable_get(:@vars)
    sass_script = {}
    ruby.each do |name, value|
      sass_script[Sass::Script::String.new(name)] = value
    end
    Sass::Script::Value::Map.new(sass_script)
  end

  if defined?(::Middleman)
    def asset_url(path, prefix)
      Sass::Script::String.new(options[:sprockets][:context].asset_url(path.value, prefix.value))
    end
  end

  private
  def parse_variables(uri)
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

