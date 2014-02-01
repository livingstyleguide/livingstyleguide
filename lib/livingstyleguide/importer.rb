class LivingStyleGuide::Importer < Sass::Importers::Filesystem

  def initialize(root)
    super(root)
  end

  def find_relative(name, base, options, absolute = false)
    @options = options
    engine = super(name, base, options)
    find_markdown(options[:filename])
    engine
  end

  def find(name, options)
    @options = options
    super(name, options)
  end

  private
  def find_markdown(sass_filename)
    files << sass_filename
    glob = "#{sass_filename.sub(/\.s[ac]ss$/, '')}.md"
    Dir.glob(glob) do |markdown_filename|
      files << markdown_filename
      markdown << File.read(markdown_filename)
    end
  end

  private
  def files
    @options[:living_style_guide].files
  end

  private
  def markdown
    @options[:living_style_guide].markdown
  end

end

