require 'erb'

module LivingStyleGuide::Renderer

  def render_living_style_guide
    data = Class.new do
      attr_accessor :css, :html, :title
      include ERB::Util
      def get_binding; binding end
    end.new
    data.css   = self.render
    markdown   = LivingStyleGuide.markdown || ''
    data.html  = LivingStyleGuide::RedcarpetTemplate.new{ markdown }.render
    data.title = @options[:living_style_guide][:title]
    LivingStyleGuide.reset
    template   = File.read(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'layouts', 'default.html.erb'))
    ERB.new(template).result(data.get_binding)
  end

end

