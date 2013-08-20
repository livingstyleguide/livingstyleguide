
module LivingStyleGuide::Renderer

  def render_living_style_guide
    markdown_file = @options[:original_filename].sub(/s[ac]ss$/, 'md')
    template = LivingStyleGuide::RedcarpetTemplate.new do
      begin
        markdown = File.read(markdown_file)
        File.delete(markdown_file)
        markdown
      rescue
        ''
      end
    end
    template.render
  end

end

