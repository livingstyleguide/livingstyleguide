LivingStyleGuide.command :colors do |arguments, options, content|
  colors = content.split(/\n+/).map{ |l| l.strip.split(/\s+/) }
  columns = colors.map{ |l| l.size }.max
  colors = colors.flatten

  document.scss << <<-SCSS
    $lsg--variables: () !default;
    $lsg--variables: join(
      $lsg--variables, (#{
        colors.reject{ |c| c == '-' }.map do |variable|
          %Q("#{variable}": #{variable})
        end.join(', ')
      })
    );
  SCSS

  colors_html = colors.map do |variable|
    if variable == "-"
      %Q(<li class="lsg--color-swatch -lsg-empty"></li>\n)
    else
      unless variable =~ /^(#[0-9a-f]{3,6}|[a-z]+)$/
        source = %Q(<span class="lsg--color-swatch-source">#{variable}</span>)
      end
      value = %Q(<span class="lsg--color-swatch-value #{variable}"></span>)
      %Q(<li class="lsg--color-swatch #{variable}">#{source}#{value}</li>\n)
    end
  end.join("\n")
  %(<ul class="lsg--color-swatches -lsg-#{columns}-columns">\n#{colors_html}\n</ul>\n)
end
