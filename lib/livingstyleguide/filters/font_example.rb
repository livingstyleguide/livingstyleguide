LivingStyleGuide::Example.add_filter :font_example do |font|
  suppress_code_block

  html do |content|
    %(<div class="livingstyleguide--font-example" style="font: #{font}">\n#{content}\n</div>\n)
  end

  filter_example do |content|
    <<-HTML
      ABCDEFGHIJKLMNOPQRSTUVWXYZ<br>
      abcdefghijklmnopqrstuvwxyz<br>
      0123456789<br>
      !&/()$=@;:,.
    HTML
  end
end

