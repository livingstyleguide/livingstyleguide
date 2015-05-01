LivingStyleGuide.add_filter :title do |arguments, options, block|
  document.title = arguments.first
  nil
end

%w(head header footer).each do |part|
  eval <<-RUBY
    LivingStyleGuide.add_filter :#{part} do |arguments, options, block|
      if template = Tilt[options[:type]]
        block = template.new{ block }.render
      end
      document.#{part} << block + "\n"
      nil
    end
  RUBY
end
