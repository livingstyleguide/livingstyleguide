LivingStyleGuide::Example.add_filter :colors do |file|
  suppress_code_block


  if file
    colors = [LivingStyleGuide::VariablesImporter.variables(file)]
  else
    colors = []
  end

  html do |content|
    content
  end

  pre_processor do |content|
    colors += content.split(/\n+/).map{ |l| l.split(/\s+/) }
    columns = colors.map{ |l| l.size }.max
    colors_html = colors.flatten.map do |variable|
      if variable == '-'
        css_class = '-lsg-empty'
      elsif variable[0] != '$'
        variable = "$#{variable}"
      end
      %Q(<li class="livingstyleguide--color-swatch #{css_class || variable}">#{variable}</li>\n)
    end.join("\n")
    %(<ul class="livingstyleguide--color-swatches -lsg-#{columns}-columns">\n#{colors_html}\n</ul>\n)
  end
end

