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

