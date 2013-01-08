require 'redcarpet'
require 'tilt'

module LivingStyleGuide
  class RedcarpetTemplate < ::Tilt::RedcarpetTemplate::Redcarpet2
    RENDER_OPTIONS = {
      autolink: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
      space_after_headers: true,
      superscript: true
    }

    def generate_renderer
      RedcarpetHTML.new(RENDER_OPTIONS)
    end

    def prepare
      @engine = ::Redcarpet::Markdown.new(generate_renderer, RENDER_OPTIONS)
      @output = nil
    end

    def evaluate(context, locals, &block)
      @context ||= context

      if @engine.renderer.respond_to? :middleman_app=
        @engine.renderer.middleman_app = @context
      end
      super
    end
  end

  class RedcarpetHTML < ::Redcarpet::Render::HTML
    attr_accessor :middleman_app

    def image(link, title, alt_text)
      middleman_app.image_tag(link, :title => title, :alt => alt_text)
    end

    def link(link, title, content)
      middleman_app.link_to(content, link, :title => title)
    end

    def block_code(code, language)
      if language == 'example'
        %Q(<div class="livingstyleguide--example">\n  #{code}\n</div>)
      else
        code
      end
    end

  end

  ::Tilt.register RedcarpetTemplate, 'markdown', 'mkd', 'md'
end

