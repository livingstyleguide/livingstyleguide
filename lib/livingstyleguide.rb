Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

begin
  require 'compass'
rescue LoadError
end

module LivingStyleGuide
  def self.add_filter(*keys, &block)
    Filters.add_filter(*keys, &block)
  end
end

require 'livingstyleguide/version'
require 'livingstyleguide/filter_hooks'
require 'livingstyleguide/sass_extensions'
require 'livingstyleguide/engine'
require 'livingstyleguide/markdown_extensions'
require 'livingstyleguide/tilt_template'
require 'livingstyleguide/code_block'
require 'livingstyleguide/example'
require 'livingstyleguide/document'
require 'livingstyleguide/filters'
require 'livingstyleguide/integration'
