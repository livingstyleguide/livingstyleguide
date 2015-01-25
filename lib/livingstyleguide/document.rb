# encoding: utf-8

require 'tilt'
require 'erb'
require 'digest'

class LivingStyleGuide::Document < ::Tilt::Template
  attr_accessor :source, :type, :filters, :template, :classes, :html
  attr_accessor :scss, :css, :id, :locals
  attr_accessor :head, :header, :footer, :title

  def prepare
    @type = :markdown
    @filters = LivingStyleGuide::Filters.new(self)
    @template = options.has_key?(:livingstyleguide) ? :default : :layout
    @classes = []
    @scss = ''
    @css = ''
    @locals = {}
  end

  def source
    @source ||= erb.gsub(/<%.*?%>\n?/, '')
  end

  def css
    scss_with_lsg = "#{scss}; @import 'livingstyleguide';"
    ::Sass::Engine.new(scss_with_lsg, syntax: :scss).render
  end

  def id
    @id ||= generate_id
  end

  def erb
    @erb ||= parse_filters do |name, arguments|
      arguments = arguments.map do |argument|
        %Q("#{argument.gsub('"', '\\"').gsub("\n", '\\n')}")
      end
      "<%= #{name}(#{arguments.join(', ')}) %>"
    end
  end

  def evaluate(scope, locals, &block)
    result = ERB.new(erb).result(@filters.get_binding)
    @html = case @type
    when :plain, :example
      result
    when :markdown
      renderer = LivingStyleGuide::RedcarpetHTML.new(LivingStyleGuide::Engine.default_options, self)
      redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
      redcarpet.render(result)
    else
      require "tilt/#{@type}"
      template_class.new{ result }.render(nil, @locals.merge(locals))
    end
    @classes.unshift "livingstyleguide--#{@type}-example"
    @classes.unshift "livingstyleguide--example"
    ERB.new(template_erb).result(binding)
  end

  private
  def template_erb
    File.read("#{File.dirname(__FILE__)}/templates/#{@template}.html.erb")
  end

  private
  def parse_filters
    (@type == :erb ? data.gsub('<%', '<%%') : data).gsub(/\G(.*?)((```.+?```)|\Z)/m) do
      content, code_block = $1, $2
      content.gsub(/@([\w\d_-]+)(?: ([^\{\n]+))?(?: *\{\n((?:.|\n)*?)\n\}|\n((?:  .*\n)+))?/) do
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
      data.gsub(/\G(.+?)((```.+?```)|\Z)/m) do
        content, code_block = $1, $2
        content.to_s.gsub(regexp, &block) + code_block
      end
    else
      data.gsub(regexp, &block)
    end
  end

  private
  def template_name
    @type == :markdown ? :redcarpet : @type
  end

  private
  def template_class
    case @type
    when :coffee then Tilt::CoffeeScriptTemplate
    when :erb    then Tilt::ERBTemplate
    else Tilt.const_get(@type.to_s.capitalize + 'Template')
    end
  end

  private
  def generate_id
    if @file
      @file.sub('/_', '/').gsub(/\.\w+/, '')
    else
      "section-#{Digest::SHA256.hexdigest(data)[0...6]}"
    end
  end
end

Tilt.register 'lsg', LivingStyleGuide::Document
