require "digest/sha1"

LivingStyleGuide.command :colors do |arguments, options, content|
  colors = content.split(/\n+/).map{ |l| l.strip.split(/(?<![,\(])\s+(?!\))/) }
  columns = colors.map{ |l| l.size }.max
  colors = colors.flatten

  def color_class(color)
    "lsg-color-" + Digest::SHA1.hexdigest(color)[0..7]
  end

  document.scss << <<-SCSS
    $lsg-colors: () !default;
    $lsg-colors: join(
      $lsg-colors, (#{
        colors.reject{ |c| c == '-' }.uniq.map do |color|
          %Q("#{color_class(color)}": #{color})
        end.join(', ')
      })
    );
  SCSS

  colors_html = colors.map do |color|
    if color == "-"
      %Q(<li class="lsg-color-swatch lsg-empty"></li>\n)
    else
      unless color =~ /^(#[0-9a-f]{3,6}|[a-z]+)$/
        source = %Q(<span class="lsg-color-swatch-source">#{color}</span>)
      end
      value = %Q(<span class="lsg-color-swatch-value #{color_class(color)}"></span>)
      %Q(<li class="lsg-color-swatch #{color_class(color)}">#{source}#{value}</li>\n)
    end
  end.join("\n")
  %(<ul class="lsg-color-swatches lsg-#{columns}-columns">\n#{colors_html}\n</ul>\n)
end
