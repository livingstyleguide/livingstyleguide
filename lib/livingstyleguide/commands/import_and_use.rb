require "tilt"

def map_files(glob)
  glob << ".lsg" unless glob =~ /\.(\w+|\*)$/
  glob.gsub!(/[^\/]+$/, "{_,}\\0")
  glob = File.join(document.path, glob)

  Dir.glob(glob).uniq.map do |file|
    document.depend_on file
    yield(file)
  end.join
end

LivingStyleGuide.command :import do |arguments, options, data|
  glob = arguments.first
  if glob =~ /\.s[ac]ss$/
    raise <<-ERROR.strip.squeeze
      Error: Please use `@css #{glob}` instead of `@import #{glob}`
      for importing Sass.
    ERROR
  end

  data = LivingStyleGuide.parse_data(data)

  map_files glob do |file|
    template = ::Tilt.new(file, livingstyleguide: document)
    html = template.render(document.scope, data)
    html.gsub!("\n", "\n  ")
    "\n<div>\n#{html}\n</div>\n"
  end
end

LivingStyleGuide.command :use do |arguments, options, data|
  glob = arguments.first
  map_files glob do |file|
    File.read(file)
  end
end
