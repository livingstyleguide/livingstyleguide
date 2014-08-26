# encoding: utf-8

require 'minisyntax'
require 'erb'
require 'hooks'

class LivingStyleGuide::Example
  include Hooks
  include Hooks::InstanceHooks
  include LivingStyleGuide::FilterHooks

  FILTER_REGEXP = /^@([a-z\-_]+)(?:\s+(.+?))?$/

  define_hooks :filter_before, :filter_after, :html, :pre_processor
  attr_reader :options, :engine
  @@filters = {}

  def initialize(input, options, engine)
    @options = { default_filters: [] }.merge(options)
    @engine = engine
    @source = input
    @wrapper_classes = %w(livingstyleguide--example)
    @syntax = :html
    @filters = @options[:default_filters].clone
    @output_code_block = true
    parse_filters
    apply_filters
  end

  html do |content|
    %Q(<div class="#{wrapper_classes}">\n  #{content}\n</div>\n)
  end

  def render
    html = run_last_filter_hook(:html, filtered_example)
    code_block = LivingStyleGuide::CodeBlock.new(@source, @syntax).render if @output_code_block
    "#{html}#{code_block}"
  end

  def self.add_filter(key = nil, &block)
    if key
      @@filters[key.to_sym] = block
    else
      instance_eval &block
    end
  end

  def add_wrapper_class(class_name)
    @wrapper_classes << class_name
  end

  def wrapper_classes
    @wrapper_classes.join(' ')
  end

  def suppress_code_block
    @output_code_block = false
  end

  private
  def parse_filters
    lines = @source.split(/\n/)
    @source = lines.reject do |line|
      if line =~ FILTER_REGEXP
        @filters << line
      end
    end.join("\n")
  end

  private
  def apply_filters
    @filters.each do |filter|
      set_filter *filter.match(FILTER_REGEXP)[1..2]
    end
  end

  private
  def set_filter(key, argument = nil)
    name = key.to_s.gsub('-', '_').to_sym
    unless @@filters.has_key?(name)
      raise NameError.new("Undefined filter “@#{key}” called.", name)
    end
    instance_exec argument, &@@filters[name]
  end

  private
  def filtered_example
    source = run_filter_hook(:filter_before, @source)
    source = run_last_filter_hook(:pre_processor, source)
    run_filter_hook(:filter_after, source)
  end
end

