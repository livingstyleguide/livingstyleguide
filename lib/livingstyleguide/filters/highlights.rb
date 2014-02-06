LivingStyleGuide::CodeBlock.filter_code do |code|
  code = code.gsub(/^\s*\*\*\*\n(.+?)\n\s*\*\*\*(\n|$)/m, %Q(\n<strong class="livingstyleguide--code-highlight-block">\\1</strong>\n))
  code = code.gsub(/\*\*\*(.+?)\*\*\*/, %Q(<strong class="livingstyleguide--code-highlight">\\1</strong>))
end

LivingStyleGuide::Example.filter_before do |code|
  code.gsub(/\*\*\*(.+?)\*\*\*/m, '\\1')
end

