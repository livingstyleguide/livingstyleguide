LivingStyleGuide.add_filter :haml do |arguments, options, block|
  document.type = :haml
  document.head << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/javascript-copy.html.erb")).result
  document.head << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/code-example.html.erb")).result
  nil
end
