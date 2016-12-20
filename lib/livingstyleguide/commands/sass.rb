require "sass"

LivingStyleGuide.command :scss do |arguments, options, scss|
  file = arguments.first
  if options[:scope] == "global" || file == "!global"
    document.scss << scss
  elsif file
    if document.file
      file = File.join(File.dirname(document.file), file)
    end
    css = Rails.application.assets.find_asset(arguments.first).source
    document.depend_on file
    document.scss << css
  else
    id = document.id.gsub(/[\/\.]/, '\\\\\0')
    document.scss << "##{id} {\n#{scss}\n}\n"
  end
  nil
end

LivingStyleGuide.command :sass do |arguments, options, sass|
  converted = Sass::Engine.new(sass).to_tree.to_scss unless sass.nil?
  scss(arguments, options, converted)
end
