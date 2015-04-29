require 'json'
require 'yaml'

LivingStyleGuide.add_filter :data do |arguments, options, data|
  if options[:format] == "yaml"
    document.locals.merge! Psych.load("{#{data}}")
  else
    document.locals.merge! JSON.parse("{#{data}}")
  end
  nil
end
