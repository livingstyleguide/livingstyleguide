require 'erb'

module LivingStyleGuide::Renderer

  def render_living_style_guide
    @css     = self.render
    template = File.read(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'layouts', 'default.html.erb'))
    markdown = LivingStyleGuide.markdown || ""
    @html    = LivingStyleGuide::RedcarpetTemplate.new{ markdown }.render
    LivingStyleGuide.reset
    ERB.new(template).result(binding)
  end

end

