require 'json'
require 'yaml'

LivingStyleGuide.add_filter :data do |arguments, options, data|
  if options[:format] == "yaml"
    data = Psych.load(data)
  else
    data = "{#{data}}" unless data.strip =~ /^[\[\{]/
    data = JSON.parse(data)
  end
  if data.is_a?(Array)
    document.locals = [] unless document.locals.is_a?(Array)
    document.locals.push(*data)
  else
    document.locals = {} unless document.locals.is_a?(Hash)
    document.locals.merge! data
  end
  nil
end
