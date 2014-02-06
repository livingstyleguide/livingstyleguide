require 'minisyntax'
require 'erb'
require 'hooks'

class LivingStyleGuide::Example
  include Hooks
  include Hooks::InstanceHooks
  include LivingStyleGuide::FilterHooks

  FILTER_REGEXP = /^@([a-z\-_]+)(\s+(.+?))?$/

  define_hook :filter_example
  @@filters = {}

  def initialize(input, options = {})
    @options = { default_filters: [] }.merge(options)
    @source = input
    @wrapper_classes = %w(livingstyleguide--example)
    @syntax = :html
    @filters = @options[:default_filters].clone
    parse_filters
    apply_filters
  end

  def render
    code_block = LivingStyleGuide::CodeBlock.new(@source, @syntax).render
    %Q(<div class="#{wrapper_classes}">\n  #{filtered_example}\n</div>) + "\n" + code_block
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

  private
  def wrapper_classes
    @wrapper_classes.join(' ')
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
    instance_exec argument, &@@filters[key.to_s.gsub('-', '_').to_sym]
  end

  private
  def filtered_example
    run_filter_hook(:filter_example, @source)
  end
end

