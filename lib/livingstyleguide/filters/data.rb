require 'json'

LivingStyleGuide.add_filter :data do |data|
  document.locals.merge! JSON.parse("{#{data}}")
  nil
end
