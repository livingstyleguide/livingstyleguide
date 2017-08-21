LivingStyleGuide.command :add_wrapper_class do |arguments, options, block|
  document.classes << arguments.first
  nil
end
