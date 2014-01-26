require 'livingstyleguide/version'
require 'compass'
require 'livingstyleguide/sass_extensions'
require 'livingstyleguide/variables_importer'
require 'livingstyleguide/importer'
require 'livingstyleguide/renderer'
require 'livingstyleguide/markdown_extensions'
require 'livingstyleguide/tilt_template'
require 'livingstyleguide/example'
require 'livingstyleguide/filters'

module LivingStyleGuide
  @@markdown = nil

  def self.reset
    @@markdown = nil
  end

  def self.add_markdown(markdown)
    (@@markdown ||= '') << markdown
  end

  def self.markdown
    @@markdown
  end

end

class Sass::Engine
  include LivingStyleGuide::Renderer
end

class String
  def blank?
    self.nil? || self.empty?
  end
end

require 'livingstyleguide/integration'

