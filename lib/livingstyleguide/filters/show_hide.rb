LivingStyleGuide.add_filter :show_hide do |arguments, options, content|
  document.header << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/show_hide.html.erb")).result(binding)
  nil
end
