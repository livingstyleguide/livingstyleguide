# encoding: utf-8

require 'tilt'
require 'erb'

class LivingStyleGuide::Document
  attr_accessor :source, :type, :filters

  def initialize(source, type = :plain)
    @type = type
    @source = source
    @filters = LivingStyleGuide::Filters.new(self)
  end

  def render
    run_filters
    if @type == :plain
      @source
    else
      require "tilt/#{template_name}"
      template_class.new{ @source }.render
    end
  end

  private
  def run_filters
    erb = source.gsub(/@([\w\d_-]+)(?: ([^\{\n]+))?(?: *\{\n((?:.|\n)*)\n\}|\n((?:  .*\n)+))?/) do
      name, arguments, block = $1, $2 || '', $3 || $4
      arguments = arguments.split(',').map do |argument|
        %Q("#{argument.strip.gsub('"', '\\"')}")
      end
      block = if block
        block.gsub!(/\A(\s*)((?:.|\n)+)\Z/){ $2.gsub(/^#{$1}/, '') }
        %Q("#{block.gsub('"', '\\"').gsub("\n", '\\n')}")
      end
      "<%= #{name.gsub('-', '_')}(#{[*arguments, block].compact.join(', ')}) %>"
    end
    @source = ERB.new(erb).result(@filters.get_binding)
  end

  private
  def template_name
    @type == :markdown ? :redcarpet : @type
  end

  private
  def template_class
    case @type
    when :markdown
      Tilt::RedcarpetTemplate
    when :coffee
      Tilt::CoffeeScriptTemplate
    else
      Tilt.const_get(@type.to_s.capitalize + 'Template')
    end
  end
end
