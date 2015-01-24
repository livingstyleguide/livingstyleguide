require 'tilt'

LivingStyleGuide.add_filter :import do |file|
  ::Tilt.new(file).render
end
