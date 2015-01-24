require 'tilt'

LivingStyleGuide.add_filter :import do |file|
  file << '.lsg' unless file =~ /\.(\w+|\*)$/
  ::Tilt.new(file).render
end
