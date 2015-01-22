# encoding: utf-8

require 'tilt'
require 'erb'

class LivingStyleGuide::Document
  attr_accessor :raw, :source, :type, :filters, :template

  def initialize(raw, type = :plain)
    @type = type
    @raw = raw
    @filters = LivingStyleGuide::Filters.new(self)
    @template = :default
  end

  def html
    result = ERB.new(erb).result(@filters.get_binding)
    case @type
    when :plain, :example
      result
    when :markdown
      renderer = LivingStyleGuide::RedcarpetHTML.new(LivingStyleGuide::Engine.default_options, self)
      redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
      redcarpet.render(result)
    else
      require "tilt/#{@type}"
      template_class.new{ result }.render
    end
  end

  def source
    @source ||= erb.gsub(/<%.*?%>\n?/, '')
  end

  def erb
    @erb ||= parse_filters do |name, arguments|
      arguments = arguments.map do |argument|
        %Q("#{argument.gsub('"', '\\"').gsub("\n", '\\n')}")
      end
      "<%= #{name}(#{arguments.join(', ')}) %>"
    end
  end

  def render
    ERB.new(template_erb).result(binding)
  end

  private
  def template_erb
    File.read("#{File.dirname(__FILE__)}/templates/#{@template}.html.erb")
  end

  private
  def parse_filters
    raw.gsub(/\G(.*?)((```.+?```)|\Z)/m) do
      content, code_block = $1, $2
      content.gsub(/@([\w\d_-]+)(?: ([^\{\n]+))?(?: *\{\n((?:.|\n)*)\n\}|\n((?:  .*\n)+))?/) do
        name, arguments, block = $1, $2 || '', $3 || $4
        name = name.gsub('-', '_').to_sym
        arguments = arguments.split(',').map(&:strip)
        if block
          arguments << block.gsub(/\A(\s*)((?:.|\n)+)\Z/){ $2.gsub(/^#{$1}/, '') }
        end
        yield name, arguments
      end + code_block
    end
  end

  private
  def gsub_content(regexp, &block)
    if @type == :markdown
      raw.gsub(/\G(.+?)((```.+?```)|\Z)/m) do
        content, code_block = $1, $2
        content.to_s.gsub(regexp, &block) + code_block
      end
    else
      raw.gsub(regexp, &block)
    end
  end

  private
  def template_name
    @type == :markdown ? :redcarpet : @type
  end

  private
  def template_class
    if @type == :coffee
      Tilt::CoffeeScriptTemplate
    else
      Tilt.const_get(@type.to_s.capitalize + 'Template')
    end
  end
end
