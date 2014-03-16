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

    def initialize(options = {}, engine)
      @options = options
      @engine = engine
      @options[:prefix] ||= 'livingstyleguide--'
      super @options
    end

    def header(text, header_level)
      id = slug(text)
      klass = %w(page-title headline sub-headline sub-sub-headline)[header_level]
      header_level += 1
      %Q(<h#{header_level} class="#{@options[:prefix]}#{klass}" id="#{id}"><a class="livingstyleguide--anchor" href="##{id}"></a>#{text}</h#{header_level}>\n)
    end

    def paragraph(text)
      %Q(<p class="#{@options[:prefix]}paragraph">#{text}</p>\n)
    end

    def list(contents, list_type)
      tag_name = "#{list_type.to_s[0, 1]}l"
      %Q(<#{tag_name} class="#{@options[:prefix]}#{list_type}-list">\n#{contents}</#{tag_name}>\n)
    end

    def list_item(text, list_type)
      %Q(<li class="#{@options[:prefix]}#{list_type}-list-item">#{text.strip}</li>\n)
    end

    def block_code(code, language)
      language ||= @options[:default_language]
      if language == 'example'
        Example.new(code, @options, @engine).render
      else
        CodeBlock.new(code.strip, language.to_s.strip.to_sym).render
      end
    end

    def codespan(code)
      code = ERB::Util.html_escape(code)
      %Q(<code class="#{@options[:prefix]}code-span #{@options[:prefix]}code">#{code}</code>)
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

