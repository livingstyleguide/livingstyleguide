require 'tilt'

LivingStyleGuide.add_filter :import do |glob, data = nil|
  glob << '.lsg' unless glob =~ /\.(\w+|\*)$/
  glob.gsub!(/[^\/]+$/, '{_,}\\0')
  if data
    data = JSON.parse("{#{data}}")
  end
  Dir.glob(glob).map do |file|
    ::Tilt.new(file).render(nil, data)
  end.join
end
