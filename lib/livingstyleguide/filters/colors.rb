LivingStyleGuide.add_filter :colors do |arguments, options, content|
  colors = content.split(/\n+/).map{ |l| l.strip.split(/\s+/) }
  columns = colors.map{ |l| l.size }.max
  colors = colors.flatten

  document.head << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/colors-example.html.erb")).result

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
    if variable == '-'
      css_class = '-lsg-empty'
    end
    html =  %Q(<li class="lsg--color-swatch #{css_class || variable}">)
    html += %Q(<span class="-copy-color">Click to copy variable<br>Alt + Click to copy hex-code</span>) unless css_class
    html += %Q(<span>#{variable}</span>)
    html += %Q(</li>\n)
    html
  end.join("\n")
  %(<ul class="lsg--color-swatches -lsg-#{columns}-columns">\n#{colors_html}\n</ul>\n)
end
