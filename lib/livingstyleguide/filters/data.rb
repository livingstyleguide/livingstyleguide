require 'json'

LivingStyleGuide.add_filter :data do |arguments, data|
  document.locals.merge! JSON.parse("{#{data}}")
  nil
end
