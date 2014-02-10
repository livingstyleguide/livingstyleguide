LivingStyleGuide::Example.add_filter :colors do |file|
  suppress_code_block


  if file
    colors = LivingStyleGuide::VariablesImporter.variables(file)
  else
    colors = []
  end

  html do |content|
    %(<ul class="livingstyleguide--color-swatches">\n#{content}\n</ul>\n)
  end

  pre_processor do |content|
    colors.map do |variable|
      %Q(<li class="livingstyleguide--color-swatch $#{variable}">$#{variable}</li>\n)
    end.join("\n")
  end
end

