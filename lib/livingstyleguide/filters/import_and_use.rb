require 'tilt'
require 'yaml'

def map_files(glob, &block)
  glob << '.lsg' unless glob =~ /\.(\w+|\*)$/
  glob.gsub!(/[^\/]+$/, '{_,}\\0')
  glob = File.join(document.path, glob)

  Dir.glob(glob).map do |file|
    document.depend_on file
    yield(file)
  end.join
end

LivingStyleGuide.add_filter :import do |arguments, options, data|
  glob = arguments.first
  if glob =~ /\.s[ac]ss$/
    raise "Error: Please use `@css #{glob}` instead of `@import #{glob}` for importing Sass."
  end

  if data
    data = Psych.safe_load(data)
  end

  map_files glob do |file|
    html = ::Tilt.new(file, livingstyleguide: document).render(document.scope, data)
    html.gsub!("\n", "\n  ")
    "\n<div>\n#{html}\n</div>\n"
  end
end

LivingStyleGuide.add_filter :use do |arguments, options, data|
  glob = arguments.first
  map_files glob do |file|
    File.read(file)
  end
end
