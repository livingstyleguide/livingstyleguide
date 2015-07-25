LivingStyleGuide.add_filter :javascript do |arguments, options, block|
  document.type = :javascript
  document.template = :javascript
  document.head << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/javascript-copy.html.erb")).result
  document.head << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/code-example.html.erb")).result
  nil
end
