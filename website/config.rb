require "compass-placeholders"

activate :livereload

page "/"
page "/changelog.html"
page "/blog.html"

set :css_dir, "style"
set :js_dir, "javascripts"
set :images_dir, "images"

set :haml, { attr_wrapper: %Q("), format: :html5 }

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

after_build do
  File.rename "build/.htaccess.html", "build/.htaccess"
end

require "fileutils"
Dir.glob "source/images/graphics/*@2x.png" do |file|
  new_file = file.sub("graphics", "graphics-2x").sub("@2x", "")
  FileUtils.mv file, new_file
end

helpers do
  def livingstyleguide_gem_version
    # Prefer `git tag` over version.rb as tags are released:
    versions = `cd .. && git tag --sort=version:refname`.split(/\n/)
    current  = versions.last
    current.sub(/^v/, "")
  rescue
    "0.0.0"
  end

  def markdown_partial(filename)
    filename.gsub! /(.+)\/(.+)/, "source/\\1/_\\2.md" unless filename =~ /\.md$/
    markdown = File.read(filename)
    renderer = LivingStyleGuide::RedcarpetHTML.new({})
    redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
    %Q(<article class="markdown">\n#{redcarpet.render(markdown)}\n</article>)
  end

  def current_branch
    `git rev-parse --abbrev-ref HEAD`.strip
  end

  def current_url
    "http://livingstyleguide.org#{current_page.url}"
  end
end

activate :blog do |blog|
  blog.sources = "blog/:year-:month-:day-:title.html"
  blog.permalink = ":title.html"
  blog.layout = "blog-post"
end

LivingStyleGuide.command :old_code_markers do |arguments, options, code|
  type = arguments.first
  code = ERB::Util.h(code)
  code.gsub!(/^\s*\*\*\*\n(.+?)\n\s*\*\*\*(\n|$)/m, %Q(\n<strong class="lsg--code-highlight-block">\\1</strong>\n))
  code.gsub!(/\*\*\*(.+?)\*\*\*/, %Q(<strong class="lsg--code-highlight">\\1</strong>))
  code = ::MiniSyntax.highlight(code.strip, type.to_sym)
  code.gsub!(/\n/, "<br>")
  <<-HTML
<div class="lsg--example">
  <pre class="lsg--code-block"><code class="lsg--code">#{code}</code></pre>
</div>
HTML
end

LivingStyleGuide.command :plain_code do |arguments, options, code|
  code = ERB::Util.h(code)
  code.gsub!(/\n/, "<br>")
  <<-HTML
<div class="lsg--example">
  <pre class="lsg--code-block"><code class="lsg--code">#{code}</code></pre>
</div>
HTML
end
