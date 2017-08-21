LivingStyleGuide.default_options[:search_box] = {
  placeholder: "Search …"
}

LivingStyleGuide.command :search_box do |arguments, options, content|
  placeholder = options[:placeholder]
  placeholder ||= LivingStyleGuide.default_options[:search_box][:placeholder]
  document.before <<
    LivingStyleGuide.template("search-box.html.erb", binding)
  document.javascript <<
    LivingStyleGuide.template("scripts/search.js.erb", binding)
  nil
end
