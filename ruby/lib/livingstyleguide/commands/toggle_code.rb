LivingStyleGuide.command :toggle_code do |arguments, options, content|
  document.before << LivingStyleGuide.template("toggle-code.html.erb", binding)
  nil
end
