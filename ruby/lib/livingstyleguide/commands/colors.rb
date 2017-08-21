require "digest/sha1"

LivingStyleGuide.command :colors do |arguments, options, content|
  colors = content.split(/\n+/).map { |l| l.strip.split(/(?<![,\(])\s+(?!\))/) }
  columns = colors.map(&:size).max
  colors = colors.flatten

  def color_class(color)
    "lsg-color-" + Digest::SHA1.hexdigest(color)[0..7]
  end

  colors_as_sass_map = colors.reject { |c| c == "-" }.uniq.map do |color|
    %Q("#{color_class(color)}": #{color})
  end.join(", ")
  document.scss << <<-SCSS
    $lsg-colors: () !default;
    $lsg-colors: join($lsg-colors, (#{colors_as_sass_map}));
  SCSS

  colors_html = colors.map do |color|
    if color == "-"
      %(<li class="lsg-color-swatch lsg-empty"></li>\n)
    else
      unless color =~ /^(#[0-9a-f]{3,6}|[a-z]+)$/
        source = %(<span class="lsg-color-swatch-source">#{color}</span>)
      end
      class_name = "lsg-color-swatch-value #{color_class(color)}"
      value = %(<span class="#{class_name}"></span>)
      class_name = "lsg-color-swatch #{color_class(color)}"
      %(<li class="#{class_name}">#{source}#{value}</li>\n)
    end
  end.join("\n")
  class_name = "lsg-color-swatches lsg-#{columns}-columns"
  %(<ul class="#{class_name}">\n#{colors_html}\n</ul>\n)
end
