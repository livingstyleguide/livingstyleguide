LivingStyleGuide.command :title do |arguments, options, block|
  document.title = arguments.first
  nil
end

{ before: :head, after: :footer }.each do |name, destination|
  LivingStyleGuide.command :"javascript_#{name}" do |arguments, options, block|
    content = document.send(:"#{destination}")
    if src = arguments.first
      content << %Q(<script src="#{src}"></script>)
    else
      if options[:transpiler] == "coffee-script"
        block = Tilt["coffee"].new { block }.render
      end
      content << %Q(<script>\n#{block}\n</script>)
    end
    document.send(:"#{destination}=", content)
    nil
  end
end

%w(head header footer before after).each do |destination|
  LivingStyleGuide.command :"#{destination}" do |arguments, options, block|
    content = document.send(:"#{destination}")
    html = LivingStyleGuide::Document.new(livingstyleguide: document) do
      block
    end
    html.type = options[:type]
    content << html.render + "\n"
    document.send(:"#{destination}=", content)
    nil
  end
  nil
end
