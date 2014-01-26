LivingStyleGuide::Example.add_filter do
  filter_code do |code|
    code = code.gsub(/^\s*\*\*\*\n(.+?)\n\s*\*\*\*(\n|$)/m, %Q(<strong class="livingstyleguide--code-highlight-block">\\1</strong>))
    code = code.gsub(/\*\*\*(.+?)\*\*\*/, %Q(<strong class="livingstyleguide--code-highlight">\\1</strong>))
  end

  filter_example do |code|
    code.gsub(/\*\*\*(.+?)\*\*\*/m, '\\1')
  end
end

