# encoding: utf-8

require "tilt"
require "erb"
require "digest"
require "pathname"

class LivingStyleGuide::Document < ::Tilt::Template
  attr_accessor :source, :type, :commands, :template, :classes, :html
  attr_accessor :css, :id, :locals
  attr_accessor :title
  attr_accessor :syntax
  attr_reader :scope

  %w(
    scss head header footer defaults javascript before after files
  ).each do |attr|
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
        instance_variable_set("@#{attr}", value)
      end
    end
  end

  def logo
    LivingStyleGuide.template("logo.html.erb", binding)
  end

  def prepare
    if options.has_key?(:livingstyleguide)
      @template = :default
    else
      @template = :layout
      @files = []
    end
    @type = :lsg
    @commands = LivingStyleGuide::Commands.new(self)
    @classes = []
    @scss = ""
    @css = ""
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
    scss_with_lsg = %Q(#{scss}; @import "livingstyleguide";)
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
    @erb ||= parse_commands do |name, arguments, options, block|
      global = "document.defaults[:global]"
      scoped = "document.defaults[:@#{name}] || {}"
      local = options.inspect
      options = "#{global}.merge(#{scoped}).merge(#{local})"
      "<%= #{name}(#{arguments.inspect}, #{options}, #{block.inspect}) %>\n"
    end
  end

  def evaluate(scope, locals, &block)
    @head = ""
    @javascript = ""
    %w(copy copy_code copy_colors toggle_code).each do |partial|
      file = "scripts/#{partial}.js.erb"
      @javascript << LivingStyleGuide.template(file, binding)
    end
    @header = ""
    @before = ""
    @after = ""
    @footer = ""
    @scope = scope
    result = ERB.new(erb).result(@commands.get_binding)
    @source = result
    @html = render_html(result, locals)
    @classes.unshift "lsg-#{@type}-example"
    @classes.unshift "lsg-example"
    ERB.new(template_erb).result(binding).gsub(/\n\n+/, "\n")
  end

  def depend_on(file)
    files << file
    @scope.depend_on(File.expand_path(file)) if @scope.respond_to?(:depend_on)
  end

  private

  def render_html(result, locals)
    if @type == :lsg
      renderer_options = LivingStyleGuide.default_options
      renderer = LivingStyleGuide::RedcarpetHTML.new(self, renderer_options)
      redcarpet_options = LivingStyleGuide::REDCARPET_RENDER_OPTIONS
      redcarpet = ::Redcarpet::Markdown.new(renderer, redcarpet_options)
      redcarpet.render(result)
    elsif engine = Tilt[@type]
      begin
        require "tilt/#{template_name}"
      rescue LoadError
      end
      template = engine.new { remove_highlights(result) }
      (@locals.is_a?(Array) ? @locals : [@locals]).map do |current_locals|
        template.render(@scope || Object.new, current_locals.merge(locals))
      end.join("\n")
    elsif @type == :escaped
      ERB::Util.h(remove_highlights(result))
    else
      remove_highlights(result)
    end
  end

  def set_highlights(code)
    code, positions = remove_highlight_marker_and_save_positions(code)
    html = yield(code)
    insert_html_highlight_marker(html, positions)
  end

  def remove_highlight_marker_and_save_positions(code)
    positions = []
    index = 0
    code_without_highlights = code.gsub(/(.*?)\*\*\*/m) do
      positions << index += $1.length
      $1
    end
    [code_without_highlights, positions]
  end

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
            code_with_highlights << %Q(<strong class="lsg-code-highlight">)
            inside_highlight = true
          end
          next_position = positions.shift
        end
        if char == "&"
          inside_character = true
        elsif inside_character && char == ";"
          inside_character = false
          index += 1
        elsif not inside_character
          index += 1
        end
      end
      code_with_highlights << char
    end
    code_with_highlights << %Q(</strong>) if inside_highlight
    code_with_highlights
  end

  def remove_highlights(code)
    code.gsub(/\*\*\*/, "")
  end

  def template_erb
    File.read("#{File.dirname(__FILE__)}/templates/#{@template}.html.erb")
  end

  def parse_commands
    doc = (data || "").gsub("<%", "<%%")
    doc.gsub(/\G(?<content>.*?)(?<code_block>(?:```.+?```)|\Z)/m) do
      content = $~[:content]
      code_block = $~[:code_block]
      content.gsub!(LivingStyleGuide::COMMANDS_REGEXP) do
        name = $~[:name].tr("-", "_").to_sym
        options = {}
        arguments = parse_arguments($~[:arguments], options)
        block = parse_block($~[:braces], $~[:indented], $~[:colon], options)
        yield name, arguments, options, block
      end
      content.gsub!(/^\\@/, "@")
      content + code_block
    end
  end

  def parse_arguments(arguments_string, options)
    return [] if arguments_string.nil?
    arguments = arguments_string.split(/(?<!\\);/)
    arguments.map! do |argument|
      argument.strip!
      argument.gsub! "\\;", ";"
      if /^(?<key>[a-zA-Z0-9_\-]+):(?<value>.+)$/ =~ argument
        options[key.downcase.tr("-", "_").to_sym] = remove_quots(value.strip)
        nil
      else
        remove_quots(argument)
      end
    end
    arguments.compact
  end

  def parse_block(braces_block, indented_block, colon_block, options)
    if braces_block
      options[:block_type] = :braces
      braces_block
    elsif indented_block
      options[:block_type] = :indented
      unindent(indented_block)
    elsif colon_block
      options[:block_type] = :colon
      colon_block
    else
      options[:block_type] = :none
      nil
    end
  end

  def unindent(block)
    block.gsub(/\A\n(?<indent>(?: |\t)*)(?<content>(?:.|\n)+)\Z/) do
      $~[:content].gsub(/^#{$~[:indent]}/, "")
    end
  end

  def remove_quots(string)
    string.sub(/^"(.*)"$|^"(.*)"$|^(.*)$/, "\\1\\2\\3").gsub(/\\("|")/, "\\1")
  end

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

  def template_name
    @type == :lsg || @type == :markdown ? :redcarpet : @type
  end

  def generate_id
    if @file
      id = Pathname.new(@file).cleanpath.to_s
      id.sub("/_", "/").gsub(/\.\w+/, "")
    else
      "section-#{Digest::SHA256.hexdigest(data)[0...6]}"
    end
  end

  def scss_template
    ::LivingStyleGuide.default_options[:scss_template] || Tilt["scss"]
  end

  def render_scss(scss)
    sass_options = options.merge(custom: { sprockets_context: @scope })
    sass_options[:load_paths] ||= []
    sass_options[:load_paths] << Dir.pwd
    if defined?(Compass)
      Compass.sass_engine_options[:load_paths].each do |path|
        sass_options[:load_paths] << path
      end
    end
    template = scss_template.new(file, sass_options) { scss }
    template.render(@scope || Object.new)
  end
end

Tilt.register LivingStyleGuide::Document, "lsg"
