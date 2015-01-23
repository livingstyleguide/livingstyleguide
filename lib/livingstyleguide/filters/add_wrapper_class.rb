LivingStyleGuide::Example.add_filter :add_wrapper_class do |css_class|
  add_wrapper_class css_class
end

LivingStyleGuide.add_filter :add_wrapper_class do |css_class|
  document.classes << css_class
end
