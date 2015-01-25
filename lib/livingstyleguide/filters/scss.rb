LivingStyleGuide.add_filter :scss do |source|
  document.scss << "##{document.id.gsub('/', '\\/')} {\n#{source}\n}\n"
  nil
end
