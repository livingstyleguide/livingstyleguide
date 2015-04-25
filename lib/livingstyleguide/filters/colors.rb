LivingStyleGuide.add_filter :colors do |arguments, content|
  colors = content.split(/\n+/).map{ |l| l.strip.split(/\s+/) }
  columns = colors.map{ |l| l.size }.max
  colors = colors.flatten
  document.scss << <<-SCSS
    $livingstyleguide--variables: () !default;
    $livingstyleguide--variables: join(
      $livingstyleguide--variables, (#{
        colors.reject{ |c| c == '-' }.map do |variable|
          %Q("#{variable}": #{variable})
        end.join(', ')
      })
    );
  SCSS
  colors_html = colors.map do |variable|
    if variable == '-'
      css_class = '-lsg-empty'
    end
    %Q(<li class="livingstyleguide--color-swatch #{css_class || variable}">#{variable}</li>\n)
  end.join("\n")
  %(<ul class="livingstyleguide--color-swatches -lsg-#{columns}-columns">\n#{colors_html}\n</ul>\n)
end
