LivingStyleGuide.add_filter :type do |arguments, options, block|
  document.type = arguments.first.to_sym
  nil
end
