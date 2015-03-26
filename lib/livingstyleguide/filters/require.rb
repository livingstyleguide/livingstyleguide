LivingStyleGuide.add_filter :require do |file|
  Kernel.require file
  nil
end
