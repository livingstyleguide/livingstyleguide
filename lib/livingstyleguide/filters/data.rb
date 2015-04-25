require 'json'

LivingStyleGuide.add_filter :data do |arguments, options, data|
  document.locals.merge! JSON.parse("{#{data}}")
  nil
end
