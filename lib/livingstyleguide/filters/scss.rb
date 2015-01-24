LivingStyleGuide.add_filter :scss do |source|
  document.scss << "##{document.id} {\n#{source}\n}\n"
  nil
end
