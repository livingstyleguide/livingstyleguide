if defined?(Sprockets)
  begin
    require "sprockets"
    Sprockets.register_engine(".lsg", ::LivingStyleGuide::Document)
    Sprockets.append_path(::LivingStyleGuide::SASS_PATH)
  rescue LoadError
  end
end
