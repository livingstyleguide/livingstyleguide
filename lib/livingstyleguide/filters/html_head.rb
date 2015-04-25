LivingStyleGuide.add_filter :title do |arguments, options, block|
  document.title = arguments.first
  nil
end
