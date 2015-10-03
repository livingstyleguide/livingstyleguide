LivingStyleGuide.add_filter :title do |arguments, options, block|
  document.title = arguments.first
  nil
end

{ :before => :head, :after => :footer }.each do |name, destination|
  eval <<-RUBY
    LivingStyleGuide.add_filter :javascript_#{name} do |arguments, options, block|
      if src = arguments.first
        document.#{destination} << %Q(<script src="\#{src}"></script>)
      else
        if options[:transpiler] == "coffee-script"
          block = Tilt["coffee"].new{ block }.render
        end
        document.#{destination} << %Q(<script>\\n\#{block}\\n</script>)
      end
      nil
    end
  RUBY
end

%w(head header footer before after).each do |part|
  eval <<-RUBY
    LivingStyleGuide.add_filter :#{part} do |arguments, options, block|
      html = LivingStyleGuide::Document.new(livingstyleguide: document) { block }
      html.type = options[:type]
      document.#{part} << html.render + "\n"
      nil
    end
  RUBY
  nil
end
