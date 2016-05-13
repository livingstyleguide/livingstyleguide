require "sass"

LivingStyleGuide.command :scss do |arguments, options, scss|
  file = arguments.first
  if file
    if document.file
      file = File.join(File.dirname(document.file), file)
    end
    document.depend_on file
    document.scss << %Q(@import "#{file}";\n)
  elsif options[:scope] == "global"
    document.scss << scss
  else
    id = document.id.gsub(/[\/\.]/, '\\\\\0')
    document.scss << "##{id} {\n#{scss}\n}\n"
  end
  nil
end

LivingStyleGuide.command :sass do |arguments, options, sass|
  file = arguments.first
  if file
    scss(arguments, options, nil)
  else
    converted = Sass::Engine.new(sass).to_tree.to_scss
    scss(arguments, options, converted)
  end
  nil
end
