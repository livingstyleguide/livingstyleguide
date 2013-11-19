require 'erb'

module LivingStyleGuide::Renderer

  def render_living_style_guide
    @css          = self.render
    markdown_file = @options[:original_filename].sub(/s[ac]ss$/, 'md')
    template      = File.read(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'layouts', 'default.html.erb'))
    @html         = LivingStyleGuide::RedcarpetTemplate.new do
      begin
        source = File.read(markdown_file)
        File.delete(markdown_file)
        source
      rescue
        ''
      end
    end.render
    ERB.new(template).result(binding)
  end

end

