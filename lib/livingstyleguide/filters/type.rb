LivingStyleGuide.add_filter :type do |name|
  document.type = name.to_sym
  nil
end
