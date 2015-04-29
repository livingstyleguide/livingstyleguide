LivingStyleGuide.add_filter :default do |arguments, options, block|
  document.defaults[arguments.first.to_sym] ||= {}
  document.defaults[arguments.first.to_sym].merge(options)
end
