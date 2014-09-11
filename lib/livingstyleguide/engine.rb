module LivingStyleGuide

  class Engine
    attr_accessor :markdown, :files, :options, :variables

    @@default_options = {
      default_language: 'example',
      title: 'Living Style Guide',
      header: '<h1 class="livingstyleguide--page-title">Living Style Guide</h1>',
      footer: '<div class="livingstyleguide--footer"><a class="livingstyleguide--logo" href="http://livingstyleguide.org">Made with the LivingStyleGuide gem.</a></div>',
      root: '/'
    }

    def self.default_options
      @@default_options
    end

    def initialize(options, sass_options)
      @options = @@default_options.merge(options)
      @sass_options = sass_options
      @variables = {}
      @files = []
      @markdown = ''
    end

    def render
      template('layout.html.erb')
    end

    def files
      collect_data if @files.empty?
      @files
    end

    def variables
      collect_data if @variables.empty?
      @variables
    end

    def markdown
      generate_markdown if @markdown.empty?
      @markdown
    end

    def sass
      separator = @options[:syntax] == :sass ? "\n" : ';'
      [
        %Q(@import "#{@options[:source]}"),
        style_variables,
        %Q(@import "livingstyleguide"),
        @options[:styleguide_sass] || @options[:styleguide_scss]
      ].flatten.join(separator)
    end

    def css
      sass_engine.render
    end

    def html
      renderer = RedcarpetHTML.new(@options, self)
      redcarpet = ::Redcarpet::Markdown.new(renderer, REDCARPET_RENDER_OPTIONS)
      redcarpet.render(markdown)
    end

    private
    def collect_data
      traverse_children sass_engine.to_tree
    end

    private
    def traverse_children(node)
      node.children.each do |child|
        if child.is_a?(Sass::Tree::ImportNode)
          add_file child.imported_file.to_tree
        elsif child.is_a?(Sass::Tree::VariableNode)
          add_variable child
        end
      end
    end

    private
    def add_file(node)
      filename = File.expand_path(node.filename)
      if local_sass_file?(filename)
        @files << filename
        traverse_children node
      end
    end

    private
    def add_variable(node)
      key = import_filename(node.filename)
      @variables[key] ||= []
      @variables[key] << node.name
    end

    private
    def local_sass_file?(filename)
      @local_sass_file_regexp ||= /^#{File.expand_path(@options[:root])}\/.+\.s[ac]ss$/
      filename =~ @local_sass_file_regexp
    end

    private
    def import_filename(filename)
      @import_filename_regexp ||= /(?<=^|\/)_?([^\/]+?)\.s[ac]ss$/
      filename.sub(@import_filename_regexp, '\\1')
    end

    private
    def sass_engine
      return @sass_engine if @sass_engine
      sass_options = @sass_options.clone
      sass_options[:living_style_guide] = self
      @sass_engine = ::Sass::Engine.new(sass, sass_options)
      collect_data
      @sass_engine
    end

    private
    def style_variables
      return unless @options.has_key?(:style)
      @options[:style].map do |key, value|
        "$livingstyleguide--#{key}: #{value}"
      end
    end

    private
    def generate_markdown
      files.clone.each do |sass_filename|
        next unless sass_filename.is_a?(String)
        glob = "#{sass_filename.sub(/\.s[ac]ss$/, '')}.md"
        Dir.glob(glob) do |markdown_filename|
          next if files.include?(markdown_filename)

          files << markdown_filename
          @markdown << File.read(markdown_filename)
        end
      end
    end

    private
    def template(filename)
      data = TemplateData.new(self)
      erb = File.read(File.join(File.dirname(__FILE__), 'templates', filename))
      ERB.new(erb).result(data.get_binding)
    end

  end

  class TemplateData
    include ERB::Util

    def initialize(engine)
      @engine = engine
    end

    def get_binding
      binding
    end

    def title
      @engine.options[:title]
    end

    def css
      @engine.css
    end

    def variables
      @engine.variables
    end

    def html
      @engine.html
    end

    def head
      javascript_tags_for(@engine.options[:javascript_before]).join("\n")
    end

    def header
      contents = [@engine.options[:header]]
      contents.join("\n")
    end

    def footer
      contents = [@engine.options[:footer]]
      contents << javascript_tags_for(@engine.options[:javascript_after])
      contents.join("\n")
    end

    private
    def javascript_tags_for(list)
      return [] unless list
      list.map do |src|
        if src =~ /\.js$/
          %Q(<script src="#{src}"></script>)
        else
          %Q(<script>#{src}</script>)
        end
      end
    end

  end

end
