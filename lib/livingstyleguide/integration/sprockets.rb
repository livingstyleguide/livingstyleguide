begin
  require 'sprockets'
  Sprockets.register_engine('.lsg', ::LivingStyleGuide::Document)
rescue LoadError
end

