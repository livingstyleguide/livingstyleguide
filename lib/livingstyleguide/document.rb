# encoding: utf-8

require 'tilt'
require 'erb'
require 'digest'

class LivingStyleGuide::Document < ::Tilt::Template
  attr_accessor :source, :type, :filters, :template, :classes, :html
  attr_accessor :css, :id, :locals
  attr_accessor :title
  attr_reader :scope

  %w(scss head header footer).each do |attr|
    define_method attr do
      if options.has_key?(:livingstyleguide)
        options[:livingstyleguide].send(attr)
      else
        instance_variable_get("@#{attr}")
      end
    end

    define_method "#{attr}=" do |value|
      if options.has_key?(:livingstyleguide)
        options[:livingstyleguide].send("#{attr}=", value)
      else
        instance_variable_get("@#{attr}", value)
      end
    end
  end

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
    @source ||= set_highlights(erb.gsub(/<%.*?%>\n?/, ''))
  end

  def highlighted_source
    if type == :plain
      source
    else
      prepared_source = type == :html ? ERB::Util.h(source) : source
      highlighted = ::MiniSyntax.highlight(prepared_source.strip, type)
      highlighted.gsub("\n", "<br>")
    end
  end

  def css
    scss_with_lsg = "#{scss}; @import 'livingstyleguide';"
    render_scss(scss_with_lsg)
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
    @scope = scope
    depend_on file if file and options.has_key?(:livingstyleguide)
    result = ERB.new(erb).result(@filters.get_binding)
    @html = case @type
    when :plain, :example, :html, :javascript
      remove_highlights(result)
    when :markdown
      renderer = LivingStyleGuide::RedcarpetHTML.new(LivingStyleGuide.default_options, self)
      redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
      remove_highlights(redcarpet.render(result))
    else
      require "tilt/#{@type}"
      template_class.new{ remove_highlights(result) }.render(@scope, @locals.merge(locals))
    end
    @classes.unshift "livingstyleguide--#{@type}-example"
    @classes.unshift "livingstyleguide--example"
    ERB.new(template_erb).result(binding).gsub(/\n\n+/, "\n")
  end

  def depend_on(file)
    @scope.depend_on(File.expand_path(file)) if @scope.respond_to?(:depend_on)
  end

  private
  def set_highlights(code)
    code.gsub!(/^\s*\*\*\*\n(.+?)\n\s*\*\*\*(\n|$)/m, %Q(\n<strong class="livingstyleguide--code-highlight-block">\\1</strong>\n))
    code.gsub(/\*\*\*(.+?)\*\*\*/, %Q(<strong class="livingstyleguide--code-highlight">\\1</strong>))
  end

  private
  def remove_highlights(code)
    code.gsub(/\*\*\*(.+?)\*\*\*/m, '\\1')
  end

  private
  def template_erb
    File.read("#{File.dirname(__FILE__)}/templates/#{@template}.html.erb")
  end

  private
  def parse_filters
    data.gsub('<%', '<%%').gsub(/\G(.*?)((```.+?```)|\Z)/m) do
      content, code_block = $1, $2
      content.gsub(/^@([\w\d_-]+)(?: ([^\{\n]+))?(?: *\{\n((?:.|\n)*?)\n\}|\n((?:  .*\n)+))?/) do
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

  private
  def scss_template
    ::LivingStyleGuide.default_options[:scss_template] || Tilt['scss']
  end

  private
  def render_scss(scss)
    sass_options = options.merge(custom: { sprockets_context: @scope })
    if defined?(Compass)
      sass_options[:load_paths] ||= []
      Compass.sass_engine_options[:load_paths].each do |path|
        sass_options[:load_paths] << path
      end
    end
    scss_template.new(file, sass_options){ scss }.render(@scope)
  end
end

Tilt.register 'lsg', LivingStyleGuide::Document
