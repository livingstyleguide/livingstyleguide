module LivingStyleGuide::SassExtensions::Functions

  def list_variables(path)
    path = path.value
    path += '.s?ss' unless path =~ /\.s[ac]ss$/
    variables = []
    Dir.glob(path).each do |file|
      sass = File.read(file)
      variables << sass.scan(%r(\$([a-z\-_]+)\s*:))
    end
    variables.flatten!
    variables.uniq!
    variables.map! do |name|
      Sass::Script::String.new(name)
    end
    Sass::Script::List.new(variables, :space)
  end

end
