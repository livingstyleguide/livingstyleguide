LivingStyleGuide.command :style do |arguments, options, block|
  options.delete :block_type
  options.each do |key, value|
    document.scss << %Q($lsg-#{key.to_s.tr('_', '-')}: #{value};\n)
  end
  nil
end
