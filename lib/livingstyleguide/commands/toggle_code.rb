LivingStyleGuide.command :toggle_code do |arguments, options, content|
  document.header << LivingStyleGuide.template("toggle_code.html.erb", binding)
  nil
end
