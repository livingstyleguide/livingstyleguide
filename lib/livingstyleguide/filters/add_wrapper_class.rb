LivingStyleGuide.add_filter :add_wrapper_class do |arguments, block|
  document.classes << arguments.first
  nil
end
