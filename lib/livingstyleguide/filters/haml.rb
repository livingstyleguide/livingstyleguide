LivingStyleGuide::Example.add_filter :haml do
  begin

    require 'haml'
    Haml::Options.defaults[:attr_wrapper] = '"'
    @syntax = :haml

    pre_processor do |haml|
      Haml::Engine.new(haml).render.strip
    end

  rescue LoadError
    raise "Please make sure `gem 'haml'` is added to your Gemfile."
  end
end

