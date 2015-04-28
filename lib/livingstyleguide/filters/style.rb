LivingStyleGuide.add_filter :style do |arguments, options, block|
  options.delete :block_type
  options.each do |key, value|
    document.scss << %Q($livingstyleguide--#{key.to_s.gsub("_", "-")}: #{value};\n)
    nil
  end
end
