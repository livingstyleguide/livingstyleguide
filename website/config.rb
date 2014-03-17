require 'compass-placeholders'

activate :livereload

page '/', layout: false
page '/changelog.html', layout: :markdown
page '/blog.html', layout: :markdown

set :css_dir, 'style'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :haml, { attr_wrapper: '"', format: :html5 }

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

after_build do
  File.rename 'build/.htaccess.html', 'build/.htaccess'
end

require 'fileutils'
Dir.glob 'source/images/graphics/*@2x.png' do |file|
  new_file = file.sub('graphics', 'graphics-2x').sub('@2x', '')
  FileUtils.mv  file, new_file
end

helpers do
  def livingstyleguide_gem_version
    # Prefer `git tag` over version.rb as tags are released:
    versions = `cd .. && git tag`.split(/\n/)
    current  = versions.last
    current.sub(/^v/, '')
  rescue
    '0.0.0'
  end

  def markdown_partial(filename)
    filename.gsub! /(.+)\/(.+)/, 'source/\\1/_\\2.md' unless filename =~ /\.md$/
    markdown = File.read(filename)
    renderer = LivingStyleGuide::RedcarpetHTML.new({})
    redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
    %Q(<article class="markdown">\n#{redcarpet.render(markdown)}\n</article>)
  end

  def current_branch
    `git rev-parse --abbrev-ref HEAD`.strip
  end
end

LivingStyleGuide::Example.add_filter :markdown do
  begin
    @syntax = :markdown

    pre_processor do |markdown|
      renderer = LivingStyleGuide::RedcarpetHTML.new({})
      redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
      %Q(<article class="markdown">\n#{redcarpet.render(markdown)}\n</article>)
    end

  rescue LoadError
    raise "Please make sure `gem 'haml'` is added to your Gemfile."
  end
end

activate :blog do |blog|
  blog.permalink = 'blog/:title.html'
  blog.prefix = 'blog'
  blog.layout = 'markdown'
end
