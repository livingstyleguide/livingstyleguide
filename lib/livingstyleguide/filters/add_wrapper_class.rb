LivingStyleGuide.add_filter :add_wrapper_class do |css_class|
  document.classes << css_class
  nil
end
