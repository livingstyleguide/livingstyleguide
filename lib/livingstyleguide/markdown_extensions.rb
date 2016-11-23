require "redcarpet"
require "tilt"
require "minisyntax"
require "erb"

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
    def initialize(document, options = {})
      @options = options
      @options[:prefix] ||= "lsg-"
      @document = document
      @header = nil
      @ids = {}
      super @options
    end

    def header(text, header_level)
      @header = id = slug(text)
      class_names = %w(page-title headline sub-headline sub-sub-headline)
      class_name = "#{@options[:prefix]}#{class_names[header_level]}"
      header_level += 1
      %Q(<h#{header_level} class="#{class_name}" id="#{id}">) +
        %Q(<a class="lsg-anchor" href="##{id}"></a>#{text}</h#{header_level}>\n)
    end

    def paragraph(text)
      %Q(<p class="#{@options[:prefix]}paragraph">#{text}</p>\n)
    end

    def list(contents, list_type)
      tag_name = "#{list_type.to_s[0, 1]}l"
      class_name = "#{@options[:prefix]}#{list_type}-list"
      %Q(<#{tag_name} class="#{class_name}">\n#{contents}</#{tag_name}>\n)
    end

    def list_item(text, list_type)
      class_name = "#{@options[:prefix]}#{list_type}-list-item"
      %Q(<li class="#{class_name}">#{text.strip}</li>\n)
    end

    def block_code(code, language)
      language = language.to_s.strip.to_sym
      language = @options[:default_language] if language == :""
      document = Document.new(livingstyleguide: @document) { code }
      document.id = document_id
      document.type = if language == :example
                      then @document.defaults[:global][:type]
                      else language
                      end
      document.template = template_for(language)
      document.render(@document.scope)
    end

    def codespan(code)
      code = ERB::Util.html_escape(code)
      class_name = "#{@options[:prefix]}code-span #{@options[:prefix]}code"
      %Q(<code class="#{class_name}">#{code}</code>)
    end

    private

    def slug(text)
      require "active_support/core_ext/string/inflections"
      require "active_support/deprecation"
      ::ActiveSupport::Inflector.parameterize(text, "-")
    rescue LoadError
      text.downcase.gsub(/[ _\.\-!\?\(\)\[\]]+/, "-").gsub(/^-|-$/, "")
    end

    def document_id
      if @document.file
        file = File.basename(@document.file, ".lsg").sub(/^_/, "")
      end
      id = [file, @header].compact.uniq.join("-")
      if id != ""
        @ids[id] ||= 0
        @ids[id] += 1
        [id, @ids[id]].join("-")
      end
    end

    def template_for(language)
      language == :example ? :example : :code
    end
  end
end
