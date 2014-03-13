module LivingStyleGuide::SassExtensions::Functions

  def list_variables(uri)
    uri = uri.value
    variables = LivingStyleGuide::VariablesImporter.variables(uri)
    variables.map! do |name|
      Sass::Script::String.new(name)
    end
    Sass::Script::List.new(variables, :space)
  end

  if defined?(::Middleman)
    def asset_url(path, prefix)
      Sass::Script::String.new(options[:sprockets][:context].asset_url(path.value, prefix.value))
    end
  end

end

