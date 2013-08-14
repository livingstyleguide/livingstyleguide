activate :livereload

page '/', :layout => false

set :css_dir, 'style'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :haml, { attr_wrapper: '"', format: :html5 }

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
end

require 'fileutils'
Dir.glob 'source/images/graphics/*@2x.png' do |file|
  new_file = file.sub('graphics', 'graphics-2x').sub('@2x', '')
  FileUtils.mv  file, new_file
end

