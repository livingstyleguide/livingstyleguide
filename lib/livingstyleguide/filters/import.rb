require 'tilt'

LivingStyleGuide.add_filter :import do |arguments, options, data|
  glob = arguments.first
  if glob =~ /\.s[ac]ss$/
    raise "Error: Please use `@css #{glob}` instead of `@import #{glob}` for importing Sass."
  end
  glob << '.lsg' unless glob =~ /\.(\w+|\*)$/
  glob.gsub!(/[^\/]+$/, '{_,}\\0')
  if document.file
    glob = File.join(File.dirname(document.file), glob)
  end

  if data
    Kernel.require 'json'
    data = JSON.parse("{#{data}}")
  end

  Dir.glob(glob).map do |file|
    document.depend_on file
    html = ::Tilt.new(file, livingstyleguide: document).render(document.scope, data)
    html.gsub!("\n", "\n  ")
    "\n<div>\n#{html}\n</div>\n"
  end.join
end
