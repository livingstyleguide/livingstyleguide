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

  def html
    result = render
    if @type == :plain
      result
    else
      require "tilt/#{template_name}"
      template_class.new{ result }.render
    end
  end

  def erb
    parse_filters do |name, arguments|
      arguments = arguments.map do |argument|
        %Q("#{argument.gsub('"', '\\"').gsub("\n", '\\n')}")
      end
      "<%= #{name}(#{arguments.join(', ')}) %>"
    end
  end

  def render
    ERB.new(erb).result(@filters.get_binding)
  end

  private
  def parse_filters
    source.gsub(/@([\w\d_-]+)(?: ([^\{\n]+))?(?: *\{\n((?:.|\n)*)\n\}|\n((?:  .*\n)+))?/) do
      name, arguments, block = $1, $2 || '', $3 || $4
      name = name.gsub('-', '_').to_sym
      arguments = arguments.split(',').map(&:strip)
      if block
        arguments << block.gsub(/\A(\s*)((?:.|\n)+)\Z/){ $2.gsub(/^#{$1}/, '') }
      end
      yield name, arguments
    end
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
