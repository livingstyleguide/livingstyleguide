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

    def initialize(source, options, sass_options)
      @source = source
      @options = @@default_options.merge(options)
      @sass_options = sass_options
      @variables = []
      @files = []
      @markdown = ''
    end

    def render
      data = TemplateData.new(self)
      template = File.read(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'layouts', 'default.html.erb'))
      ERB.new(template).result(data.get_binding)
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

    def css
      sass_engine.render
    end

    def html
      renderer = RedcarpetHTML.new(@options)
      redcarpet = ::Redcarpet::Markdown.new(renderer, REDCARPET_RENDER_OPTIONS)
      redcarpet.render(markdown)
    end

    private
    def collect_data
      collect_data_for sass_engine.to_tree
    end

    private
    def collect_data_for(node = nil)
      @files << node.filename if node.filename =~ /\.s[ac]ss/
      node.children.each do |child|
        if child.is_a?(Sass::Tree::ImportNode)
          collect_data_for child.imported_file.to_tree
        elsif child.is_a?(Sass::Tree::VariableNode)
          @variables << child.name
        end
      end
    end

    private
    def sass_engine
      return @sass_engine if @sass_engine
      sass_options = @sass_options.clone
      sass_options[:living_style_guide] = self
      @sass_engine = ::Sass::Engine.new(@source, sass_options)
      tree = @sass_engine.to_tree
      collect_data
      tree << variables_importer(sass_options)
      @sass_engine
    end

    private
    def variables_importer(sass_options)
      vi = ::Sass::Tree::ImportNode.new(VariablesImporter::VARIABLE_IMPORTER_STRING)
      vi.options = sass_options
      vi
    end

    private
    def generate_markdown
      files.clone.each do |sass_filename|
        next unless sass_filename.is_a?(String)
        glob = "#{sass_filename.sub(/\.s[ac]ss$/, '')}.md"
        Dir.glob(glob) do |markdown_filename|
          files << markdown_filename
          @markdown << File.read(markdown_filename)
        end
      end
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

