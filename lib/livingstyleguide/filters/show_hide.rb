LivingStyleGuide.add_filter :toggle_code do |arguments, options, content|
  document.header << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/toggle_code.html.erb")).result(binding)
  nil
end
