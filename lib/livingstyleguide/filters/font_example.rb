LivingStyleGuide::Example.add_filter :font_example do |font|
  suppress_code_block

  html do |content|
    %(<div class="livingstyleguide--font-example" style="font: #{font}">\n#{content}\n</div>\n)
  end

  filter_example do |content|
    content = <<-HTML if content == ''
      ABCDEFGHIJKLMNOPQRSTUVWXYZ
      abcdefghijklmnopqrstuvwxyz
      0123456789
      !&/()$=@;:,.
    HTML
    content.strip.gsub(/\n/, "<br>\n")
  end
end

