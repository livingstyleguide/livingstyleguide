LivingStyleGuide.command :data do |arguments, options, data|
  data = LivingStyleGuide.parse_data(data)
  if data.is_a?(Array)
    document.locals = [] unless document.locals.is_a?(Array)
    document.locals.push(*data)
  else
    document.locals = {} unless document.locals.is_a?(Hash)
    document.locals.merge! data
  end
  nil
end
