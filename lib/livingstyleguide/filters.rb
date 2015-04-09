class LivingStyleGuide::Filters
  attr_reader :document

  def initialize(doc)
    @document = doc
  end

  def get_binding
    binding
  end

  def self.add_filter(*keys, &block)
    keys.each do |key|
      define_method key, &block
    end
  end
end

require 'livingstyleguide/filters/options'
require 'livingstyleguide/filters/import'
require 'livingstyleguide/filters/require'
require 'livingstyleguide/filters/full_width'
require 'livingstyleguide/filters/haml'
require 'livingstyleguide/filters/type'
require 'livingstyleguide/filters/markdown'
require 'livingstyleguide/filters/javascript'
require 'livingstyleguide/filters/coffee_script'
require 'livingstyleguide/filters/add_wrapper_class'
require 'livingstyleguide/filters/font_example'
require 'livingstyleguide/filters/colors'
require 'livingstyleguide/filters/css'
require 'livingstyleguide/filters/data'
require 'livingstyleguide/filters/html_head'
