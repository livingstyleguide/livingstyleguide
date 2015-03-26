require 'tilt'

LivingStyleGuide.add_filter :import do |glob, data = nil|
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
    if file =~ /\.s[ac]ss$/
      document.depend_on file
      document.scss << %Q(@import "#{file}";\n)
      nil
    else
      ::Tilt.new(file, livingstyleguide: document).render(document.scope, data)
    end
  end.join
end
