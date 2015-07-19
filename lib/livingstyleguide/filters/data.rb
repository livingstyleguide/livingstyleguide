require 'yaml'

LivingStyleGuide.add_filter :data do |arguments, options, data|
  data = Psych.safe_load(data)
  if data.is_a?(Array)
    document.locals = [] unless document.locals.is_a?(Array)
    document.locals.push(*data)
  else
    document.locals = {} unless document.locals.is_a?(Hash)
    document.locals.merge! data
  end
  nil
end
