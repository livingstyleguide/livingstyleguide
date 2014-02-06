require 'redcarpet'
require 'tilt'
require 'minisyntax'
require 'erb'

module LivingStyleGuide
  REDCARPET_RENDER_OPTIONS = {
    autolink: true,
    fenced_code_blocks: true,
    tables: true,
    strikethrough: true,
    space_after_headers: true,
    superscript: true
  }

  class RedcarpetHTML < ::Redcarpet::Render::HTML

    def initialize(options = {})
      @options = options
      super
    end

    def header(text, header_level)
      id = %Q( id="#{slug(text)}")
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
      language ||= @options[:default_language]
      if language == 'example'
        Example.new(code, @options).render
      else
        CodeBlock.new(code.strip, language.to_s.strip.to_sym).render
      end
    end

    def codespan(code)
      code = ERB::Util.html_escape(code)
      %Q(<code class="livingstyleguide--code-span livingstyleguide--code">#{code}</code>)
    end

    private
    def slug(text)
      require 'active_support/core_ext/string/inflections'
      ::ActiveSupport::Inflector.parameterize(text, '-')
    rescue LoadError
      text.downcase.gsub(/[ _\.\-!\?\(\)\[\]]+/, '-').gsub(/^-|-$/, '')
    end

  end
end

