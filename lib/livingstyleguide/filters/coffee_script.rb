LivingStyleGuide.add_filter :coffee_script, :coffee do |arguments, options, block|
  document.type = :coffee
  document.template = :javascript
  document.head << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/javascript-copy.html.erb")).result
  document.head << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/code-example.html.erb")).result
  nil
end
