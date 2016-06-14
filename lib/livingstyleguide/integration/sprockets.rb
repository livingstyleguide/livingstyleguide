if defined?(Sprockets)
  begin
    require "sprockets"
    Sprockets.register_engine(".lsg", ::LivingStyleGuide::Document)
    if Sprockets.respond_to?(:append_path)
      Sprockets.append_path(::LivingStyleGuide::SASS_PATH)
    end
  rescue LoadError
  end
end
