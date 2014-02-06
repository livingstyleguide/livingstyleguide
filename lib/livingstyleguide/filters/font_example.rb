LivingStyleGuide::Engine.default_options[:font_example] = { text: <<-TEXT }
  ABCDEFGHIJKLMNOPQRSTUVWXYZ
  abcdefghijklmnopqrstuvwxyz
  0123456789
  !&/()$=@;:,.
TEXT

LivingStyleGuide::Example.add_filter :font_example do |font|
  suppress_code_block

  html do |content|
    %(<div class="livingstyleguide--font-example" style="font: #{font}">\n#{content}\n</div>\n)
  end

  filter_example do |content|
    content = options[:font_example][:text] if content == ''
    content.strip.gsub(/\n/, "<br>\n")
  end
end

