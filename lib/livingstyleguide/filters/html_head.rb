LivingStyleGuide.add_filter :title do |arguments, block|
  document.title = arguments.first
  nil
end
