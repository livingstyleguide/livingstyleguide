require 'tilt'

LivingStyleGuide.add_filter :import do |glob|
  glob << '.lsg' unless glob =~ /\.(\w+|\*)$/
  glob.gsub!(/[^\/]+$/, '{_,}\\0')
  Dir.glob(glob).map do |file|
    ::Tilt.new(file).render
  end.join
end
