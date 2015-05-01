LivingStyleGuide.add_filter :title do |arguments, options, block|
  document.title = arguments.first
  nil
end

%w(head header footer).each do |part|
  eval <<-RUBY
    LivingStyleGuide.add_filter :#{part} do |arguments, options, block|
      document.#{part} << block + "\n"
      nil
    end
  RUBY
end
