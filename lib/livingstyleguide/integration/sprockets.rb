begin
  require 'sprockets'
  Sprockets.register_engine('.lsg', ::Tilt::LivingStyleGuideTemplate)
rescue LoadError
end

