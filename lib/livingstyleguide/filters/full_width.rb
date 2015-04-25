LivingStyleGuide.add_filter :full_width do |arguments, options, block|
  document.classes << '-lsg-has-full-width'
  nil
end
