require 'sass'

LivingStyleGuide.add_filter :scss do |arguments, options, scss|
  file = arguments.first
  if file
    if document.file
      file = File.join(File.dirname(document.file), file)
    end
    document.depend_on file
    document.scss << %Q(@import "#{file}";\n)
  else
    document.scss << "##{document.id.gsub(/[\/\.]/, '\\\\\0')} {\n#{scss}\n}\n"
  end
  nil
end

LivingStyleGuide.add_filter :sass do |arguments, options, sass|
  file = arguments.first
  if file
    if document.file
      file = File.join(File.dirname(document.file), file)
    end
    document.depend_on file
    document.scss << %Q(@import "#{file}";\n)
  else
    scss = Sass::Engine.new(sass).to_tree.to_scss
    document.scss << "##{document.id.gsub(/[\/\.]/, '\\\\\0')} {\n#{scss}\n}\n"
  end
  nil
end
