require 'tilt'

LivingStyleGuide.add_filter :import do |glob|
  glob << '.lsg' unless glob =~ /\.(\w+|\*)$/
  Dir.glob(glob).map do |file|
    ::Tilt.new(file).render
  end.join
end
