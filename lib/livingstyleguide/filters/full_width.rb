LivingStyleGuide::Example.add_filter :full_width do
  add_wrapper_class '-lsg-has-full-width'
end

LivingStyleGuide.add_filter :full_width do
  document.classes << '-lsg-has-full-width'
  nil
end
