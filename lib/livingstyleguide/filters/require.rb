LivingStyleGuide.add_filter :require do |arguments, options, block|
  Kernel.require arguments.first
  nil
end
