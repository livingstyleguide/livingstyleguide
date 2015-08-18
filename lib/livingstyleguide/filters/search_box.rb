LivingStyleGuide.default_options[:search_box] = {
  placeholder: "Search..."
}

LivingStyleGuide.add_filter :search_box do |arguments, options, content|
  placeholder = options[:placeholder] || LivingStyleGuide.default_options[:search_box][:placeholder]
  document.header << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/search-box.html.erb")).result(binding)
  nil
end