class LivingStyleGuide::Commands
  attr_reader :document

  def initialize(doc)
    @document = doc
  end

  def get_binding
    binding
  end

  def self.command(*keys, &block)
    keys.each do |key|
      define_method key, &block
    end
  end
end

require "livingstyleguide/commands/options"
require "livingstyleguide/commands/default"
require "livingstyleguide/commands/import_and_use"
require "livingstyleguide/commands/require"
require "livingstyleguide/commands/full_width"
require "livingstyleguide/commands/haml"
require "livingstyleguide/commands/type"
require "livingstyleguide/commands/markdown"
require "livingstyleguide/commands/javascript"
require "livingstyleguide/commands/coffee_script"
require "livingstyleguide/commands/add_wrapper_class"
require "livingstyleguide/commands/font_example"
require "livingstyleguide/commands/colors"
require "livingstyleguide/commands/css"
require "livingstyleguide/commands/sass"
require "livingstyleguide/commands/style"
require "livingstyleguide/commands/data"
require "livingstyleguide/commands/layout"
require "livingstyleguide/commands/syntax"
require "livingstyleguide/commands/search_box"
require "livingstyleguide/commands/toggle_code"
