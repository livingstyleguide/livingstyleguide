require 'redcarpet'
require 'tilt'
require 'minisyntax'
require 'erb'
require 'active_support/core_ext/string/inflections'

module LivingStyleGuide
  class RedcarpetTemplate < ::Tilt::RedcarpetTemplate::Redcarpet2
    RENDER_OPTIONS = {
      :autolink => true,
      :fenced_code_blocks => true,
      :tables => true,
      :strikethrough => true,
      :space_after_headers => true,
      :superscript => true
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

    def header(text, header_level)
      id = %Q( id="#{::ActiveSupport::Inflector.parameterize(text, '-')}")
      klass = %w(page-title headline sub-headline sub-sub-headline)[header_level]
      header_level += 1
      %Q(<h#{header_level} class="livingstyleguide--#{klass}"#{id}>#{text}</h#{header_level}>\n)
    end

    def paragraph(text)
      if text =~ /^\{\{variables:(.+)\}\}$/
        uri = $1
        result = %Q(<ul class="livingstyleguide--color-swatches">\n)
        VariablesImporter.variables(uri).each do |variable|
          result << %Q(<li class="livingstyleguide--color-swatch $#{variable}">$#{variable}</li>\n)
        end
        result << "</ul>\n"
      elsif text =~ /^\{\{font-example:(.+)\}\}$/
        font = $1
        <<-HTML.gsub('          ', '')
          <div class="livingstyleguide--font-example" style="font: #{font}">
            ABCDEFGHIJKLMNOPQRSTUVWXYZ<br>
            abcdefghijklmnopqrstuvwxyz<br>
            0123456789<br>
            !&/()$=@;:,.
          </div>
        HTML
      else
        %Q(<p class="livingstyleguide--paragraph">#{text}</p>\n)
      end
    end

    def list(contents, list_type)
      tag_name = "#{list_type.to_s[0, 1]}l"
      %Q(<#{tag_name} class="livingstyleguide--#{list_type}-list">\n#{contents}</#{tag_name}>\n)
    end

    def list_item(text, list_type)
      %Q(<li class="livingstyleguide--#{list_type}-list-item">#{text.strip}</li>\n)
    end

    def block_code(code, language)
      if %w(example layout-example).include?(language)
        html = code.gsub(/\*\*\*(.+?)\*\*\*/m, '\\1')
        %Q(<div class="livingstyleguide--#{language}">\n  #{html}\n</div>) + "\n" + block_code(code, 'html')
      elsif %w(haml-example haml-layout-example).include?(language)
        begin
          type = language[5..-1]
          require 'haml'
          Haml::Options.defaults[:attr_wrapper] = '"'
          haml = code.gsub(/\*\*\*(.+?)\*\*\*/m, '\\1')
          html = Haml::Engine.new(haml).render.strip
          %Q(<div class="livingstyleguide--#{type}">\n  #{html}\n</div>) + "\n" + block_code(code, 'haml')
        rescue LoadError
          raise "Please make sure `gem 'haml'` is added to your Gemfile."
        end
      elsif %w(javascript-example).include?(language)
        javascript = code.gsub(/\*\*\*(.+?)\*\*\*/m, '\\1')
        %Q(<script>#{javascript}</script>\n) + block_code(code, 'javascript')
      else
        code = ERB::Util.html_escape(code).gsub(/&quot;/, '"')
        code = ::MiniSyntax.highlight(code.strip, language.to_s.strip.to_sym)
        code.gsub! /^\s*\*\*\*\n(.+?)\n\s*\*\*\*(\n|$)/m, %Q(<strong class="livingstyleguide--code-highlight-block">\\1</strong>)
        code.gsub! /\*\*\*(.+?)\*\*\*/, %Q(<strong class="livingstyleguide--code-highlight">\\1</strong>)
        %Q(<pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">#{code}</code></pre>)
      end
    end

    def codespan(code)
      code = ERB::Util.html_escape(code)
      %Q(<code class="livingstyleguide--code-span livingstyleguide--code">#{code}</code>)
    end

  end

  ::Tilt.register RedcarpetTemplate, 'markdown', 'mkd', 'md'
end

