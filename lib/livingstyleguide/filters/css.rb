LivingStyleGuide.add_filter :css, :scss do |source|
  if source =~ /\.(css|scss|sass)$/
    if document.file
      source = File.join(File.dirname(document.file), source)
    end
    document.depend_on source
    document.scss << %Q(@import "#{source}";\n)
  else
    document.scss << "##{document.id.gsub('/', '\\/')} {\n#{source}\n}\n"
  end
  nil
end
