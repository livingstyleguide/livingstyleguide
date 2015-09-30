LivingStyleGuide.add_filter :before do |arguments, options, content|
  document.before << content if content
  nil
end
