LivingStyleGuide::Example.add_filter :coffee_script do
  begin

    require 'coffee-script'
    @syntax = :'coffee-script'

    add_wrapper_class '-lsg-for-javascript'

    pre_processor do |coffee_script|
      javascript = CoffeeScript.compile(coffee_script)
      %Q(<script>#{javascript}</script>\n)
    end

  rescue LoadError
    raise "Please make sure `gem 'coffee-script'` is added to your Gemfile."
  end
end

