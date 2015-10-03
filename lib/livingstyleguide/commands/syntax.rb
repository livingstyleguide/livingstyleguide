LivingStyleGuide.command :syntax do |arguments, options, block|
  document.syntax = arguments.first.to_sym
  nil
end
