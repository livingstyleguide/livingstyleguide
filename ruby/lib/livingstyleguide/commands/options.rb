LivingStyleGuide.command :set do |arguments, options, block|
  options.each do |key, value|
    document.options[key] = case value
                            when "true"
                              true
                            when "false"
                              false
                            when /^\d+$/
                              value.to_i
                            else
                              value
                            end
  end
  nil
end
