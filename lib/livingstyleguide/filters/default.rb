LivingStyleGuide.add_filter :default do |arguments, options, block|
  key = arguments.first.gsub("-", "_").to_sym
  document.defaults[key] ||= {}
  document.defaults[key].merge!(options)
  nil
end
