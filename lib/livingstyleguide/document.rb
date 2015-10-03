# encoding: utf-8

require 'tilt'
require 'erb'
require 'digest'
require 'pathname'

class LivingStyleGuide::Document < ::Tilt::Template
  attr_accessor :source, :type, :filters, :template, :classes, :html
  attr_accessor :css, :id, :locals
  attr_accessor :title
  attr_accessor :syntax
  attr_reader :scope

  %w(scss head header footer defaults javascript).each do |attr|
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
    @type = :lsg
    @filters = LivingStyleGuide::Filters.new(self)
    @template = options.has_key?(:livingstyleguide) ? :default : :layout
    @classes = []
    @scss = ''
    @css = ''
    @locals = {}
    @defaults = {
      global: {
        type: :html
      }
    }
  end

  def highlighted_source
    set_highlights(source.strip) do |without_highlights|
      if type == :plain
        without_highlights
      else
        @syntax ||= type
        without_highlights = ERB::Util.h(without_highlights) if @syntax == :html
        ::MiniSyntax.highlight(without_highlights, @syntax || type)
      end
    end.gsub("\n", "<br>")
  end

  def css
    scss_with_lsg = "#{scss}; @import 'livingstyleguide';"
    render_scss(scss_with_lsg)
  end

  def id
    @id ||= generate_id
  end

  def path
    if file
      Pathname.new(File.dirname(file)).cleanpath.to_s
    elsif options.has_key?(:livingstyleguide)
      options[:livingstyleguide].path
    else
      "."
    end
  end

  def erb
    @erb ||= parse_filters do |name, arguments, options, block|
      options = %Q(document.defaults[:global].merge(document.defaults[:@#{name}] || {}).merge(#{options.inspect}))
      "<%= #{name}(#{arguments.inspect}, #{options}, #{block.inspect}) %>\n"
    end
  end

  def evaluate(scope, locals, &block)
    scripts_path = "#{File.dirname(__FILE__)}/templates/scripts"
    @head = ""
    @javascript = ""
    %w{ copy copy_code copy_colors }.each do |partial|
      @javascript << ERB.new(File.read("#{scripts_path}/#{partial}.js.erb")).result(binding)
    end
    @header = ""
    @footer = ""
    @scope = scope
    result = ERB.new(erb).result(@filters.get_binding)
    @source = result
    @html = render_html(result, locals)
    @classes.unshift "lsg--#{@type}-example"
    @classes.unshift "lsg--example"
    ERB.new(template_erb).result(binding).gsub(/\n\n+/, "\n")
  end

  def depend_on(file)
    @scope.depend_on(File.expand_path(file)) if @scope.respond_to?(:depend_on)
  end

  private
  def render_html(result, locals)
    if @type == :lsg
      renderer = LivingStyleGuide::RedcarpetHTML.new(LivingStyleGuide.default_options, self)
      redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
      redcarpet.render(result)
    elsif engine = Tilt[@type]
      begin
        require "tilt/#{template_name}"
      rescue LoadError
      end
      template = engine.new{ remove_highlights(result) }
      (@locals.is_a?(Array) ? @locals : [@locals]).map do |current_locals|
        template.render(@scope || Object.new, current_locals.merge(locals))
      end.join("\n")
    elsif @type == :escaped
      ERB::Util.h(remove_highlights(result))
    else
      remove_highlights(result)
    end
  end

  private
  def set_highlights(code, &block)
    code, positions = remove_highlight_marker_and_save_positions(code)
    html = yield(code)
    insert_html_highlight_marker(html, positions)
  end

  private
  def remove_highlight_marker_and_save_positions(code)
    positions = []
    index = 0
    code_without_highlights = code.gsub(/(.*?)\*\*\*/m) do
      positions << index += $1.length
      $1
    end
    [code_without_highlights, positions]
  end

  private
  def insert_html_highlight_marker(html, positions)
    code_with_highlights = ""
    index = 0
    next_position = positions.shift
    inside_highlight = false
    inside_character = false
    inside_html = false
    html.each_char do |char|
      if char == "<"
        inside_html = true
      elsif char == ">"
        inside_html = false
      elsif not inside_html
        if index == next_position
          if inside_highlight
            code_with_highlights << %Q(</strong>)
            inside_highlight = false
          else
            code_with_highlights << %Q(<strong class="lsg--code-highlight">)
            inside_highlight = true
          end
          next_position = positions.shift
        end
        if char == "&"
          inside_character = true
        elsif inside_character and char == ";"
          inside_character = false
          index += 1
        elsif not inside_character
          index += 1
        end
      end
      code_with_highlights << char
    end
    code_with_highlights
  end

  private
  def remove_highlights(code)
    code.gsub(/\*\*\*/, '')
  end

  private
  def template_erb
    File.read("#{File.dirname(__FILE__)}/templates/#{@template}.html.erb")
  end

  private
  def parse_filters
    data.gsub('<%', '<%%').gsub(/\G(.*?)((```.+?```)|\Z)/m) do
      content, code_block = $1, $2
      content.gsub(/^@([\w\d_-]+)(?: ([^\n]*[^\{\n:]))?(?: *\{\n((?:.|\n)*?)\n\}|((?:\n+  .*)+(?=\n|\Z))| *:\n((?:.|\n)*?)(?:\n\n|\Z))?/) do
        name, arguments_string, block = $1, $2 || '', $3 || $4 || $5
        options = {
          block_type: $3 ? :braces : $4 ? :indented : $5 ? :block : :none
        }
        name = name.gsub('-', '_').to_sym
        arguments = parse_arguments(arguments_string, options)
        if options[:block_type] == :indented
          block.gsub!(/\A\n(\s*)((?:.|\n)+)\Z/){ $2.gsub(/^#{$1}/, '') }
        end
        yield name, arguments, options, block
      end + code_block
    end
  end

  private
  def parse_arguments(arguments_string, options)
    arguments = arguments_string.split(/(?<!\\);/)
    arguments.map! do |argument|
      argument.strip!
      argument.gsub! "\\;", ";"
      if /^(?<key>[a-zA-Z0-9_\-]+):(?<value>.+)$/ =~ argument
        options[key.downcase.gsub('-', '_').to_sym] = remove_quots(value.strip)
        nil
      else
        remove_quots(argument)
      end
    end
    arguments.compact
  end

  private
  def remove_quots(string)
    string.sub(/^"(.*)"$|^'(.*)'$|^(.*)$/, '\\1\\2\\3').gsub(/\\("|')/, "\\1")
  end

  private
  def gsub_content(regexp, &block)
    if @type == :lsg
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
    (@type == :lsg or @type == :markdown) ? :redcarpet : @type
  end

  private
  def generate_id
    if @file
      id = Pathname.new(@file).cleanpath.to_s
      id.sub('/_', '/').gsub(/\.\w+/, '')
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
    sass_options[:load_paths] ||= []
    sass_options[:load_paths] << Dir.pwd
    if defined?(Compass)
      Compass.sass_engine_options[:load_paths].each do |path|
        sass_options[:load_paths] << path
      end
    end
    scss_template.new(file, sass_options){ scss }.render(@scope || Object.new)
  end
end

Tilt.register 'lsg', LivingStyleGuide::Document
