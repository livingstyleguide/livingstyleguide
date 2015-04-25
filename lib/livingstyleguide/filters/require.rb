LivingStyleGuide.add_filter :require do |arguments, block|
  Kernel.require arguments.first
  nil
end
