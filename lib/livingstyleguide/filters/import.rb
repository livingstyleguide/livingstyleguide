require 'tilt'

LivingStyleGuide.add_filter :import do |glob, data = nil|
  glob << '.lsg' unless glob =~ /\.(\w+|\*)$/
  glob.gsub!(/[^\/]+$/, '{_,}\\0')
  if data
    data = JSON.parse("{#{data}}")
  end
  Dir.glob(glob).map do |file|
    if file =~ /\.s[ac]ss$/
      document.scss << %Q(@import "#{file}";\n)
      nil
    else
      ::Tilt.new(file, livingstyleguide: document).render(nil, data)
    end
  end.join
end
