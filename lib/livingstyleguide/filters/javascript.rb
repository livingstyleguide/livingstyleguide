LivingStyleGuide::Example.add_filter :javascript do
  @syntax = :javascript

  add_wrapper_class '-lsg-for-javascript'

  pre_processor do |javascript|
    %Q(<script>#{javascript}</script>\n)
  end
end

