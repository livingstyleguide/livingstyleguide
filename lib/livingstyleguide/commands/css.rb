LivingStyleGuide.command :css do |arguments, options, css|
  file = arguments.first
  if file =~ /\.css$/
    if document.file
      file = File.join(File.dirname(document.file), file)
    end
    document.depend_on file
    document.scss << %Q(@import "#{file}";\n)
  elsif options[:scope] == "global"
    document.scss << css
  else
    scope = "#" + document.id.gsub(/[\/\.]/, '\\\\\0')
    scoped_css = css.gsub(/(?<=\}|\A|;)[^@\};]+?(?=\{)/) do |selector|
      selector.split(",").map do |single_selector|
        "#{scope} #{single_selector}"
      end.join(",")
    end
    document.scss << scoped_css
  end
  nil
end
