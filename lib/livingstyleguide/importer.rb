class LivingStyleGuide::Importer < Sass::Importers::Filesystem

  def initialize(root)
    super(root)
  end

  def find_relative(name, base, options, absolute = false)
    @options = options
    find_markdown(File.join(File.dirname(base), name))
    super(name, base, options)
  end

  def find(name, options)
    @options = options
    find_markdown(name)
    super(name, options)
  end

  private
  def find_markdown(sass_filename)
    glob = "#{sass_filename.sub(/\.s[ac]ss$/, '')}.md"
    glob.sub!(/(.*)\//, '\\1/{_,}') unless glob =~ /\/_/
    glob = '{_,}' + glob unless glob =~ /\//
    Dir.glob(glob) do |markdown_filename|
      markdown << File.read(markdown_filename)
    end
  end

  private
  def markdown
    @options[:living_style_guide].markdown
  end

end

