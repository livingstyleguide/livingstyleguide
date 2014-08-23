begin
  require 'sprockets'
  Sprockets.register_engine('.lsg', ::LivingStyleGuide::TiltTemplate)
rescue LoadError
end

