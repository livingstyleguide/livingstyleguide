require 'erb'

module LivingStyleGuide::Renderer

  def render_living_style_guide
    data = Class.new do
      attr_accessor :css, :html, :title, :head, :header, :footer
      include ERB::Util
      def get_binding; binding end
    end.new
    data.css    = self.render
    markdown    = LivingStyleGuide.markdown || ''
    data.html   = LivingStyleGuide::RedcarpetTemplate.new{ markdown }.render
    data.title  = @options[:living_style_guide][:title]

    head        = (@options[:living_style_guide][:javascript_before] || []).map do |src|
      %Q(<script src="#{src}"></script>)
    end
    data.head   = head.join("\n")

    header      = [@options[:living_style_guide][:header]]
    data.header = header.join("\n")

    footer = [@options[:living_style_guide][:footer]]
    footer << (@options[:living_style_guide][:javascript_after] || []).map do |src|
      %Q(<script src="#{src}"></script>)
    end
    data.footer = footer.join("\n")

    LivingStyleGuide.reset
    template   = File.read(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'layouts', 'default.html.erb'))
    ERB.new(template).result(data.get_binding)
  end

end

