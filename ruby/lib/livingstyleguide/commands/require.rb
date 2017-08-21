LivingStyleGuide.command :require do |arguments, options, block|
  current_path = File.expand_path(document.path)
  $LOAD_PATH << current_path unless $LOAD_PATH.include?(current_path)
  Kernel.require arguments.first
  nil
end
