require 'livingstyleguide/version'
require 'compass'
require 'livingstyleguide/sass_extensions'
require 'livingstyleguide/variables_importer'
require 'livingstyleguide/importer'
require 'livingstyleguide/renderer'
require 'livingstyleguide/markdown_extensions'
require 'livingstyleguide/tilt_template'

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

Compass.configuration.add_import_path LivingStyleGuide::VariablesImporter.new

base_directory = File.join(File.dirname(__FILE__), '..')
Compass::Frameworks.register 'livingstyleguide', :path => base_directory

class Sass::Engine
  include LivingStyleGuide::Renderer
end

