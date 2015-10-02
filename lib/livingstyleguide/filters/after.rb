LivingStyleGuide.add_filter :after do |arguments, options, content|
  document.after << content if content
  nil
end
