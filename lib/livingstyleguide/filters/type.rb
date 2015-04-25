LivingStyleGuide.add_filter :type do |arguments, block|
  document.type = arguments.first.to_sym
  nil
end
