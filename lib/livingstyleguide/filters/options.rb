LivingStyleGuide.add_filter :set do |option|
  if option =~ /^([\w\-]+):\s+(.+)$/
    key, value = $1, $2
    key = key.downcase.gsub('-', '_').to_sym
    value = case value
    when 'true'
      true
    when 'false'
      false
    when /^\d+$/
      value.to_i
    else
      value
    end
    document.options[key] = value
    #puts key, value, document.options[key], "<<<<"
  end
  nil
end
