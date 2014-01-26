require 'minisyntax'
require 'erb'
require 'hooks'

class LivingStyleGuide::Example
  include Hooks
  include Hooks::InstanceHooks

  define_hooks :filter_example
  @@options = {}

  @classes = %w(livingstyleguide--example)

  def initialize(input)
    @source = input
    filter_example :remove_highlight_markers
    parse_options
  end

  def render
    %Q(<div class="livingstyleguide--example">\n  #{filtered_example}\n</div>) + "\n" + display_source
  end

  def self.add_option(key, &block)
    @@options[key.to_sym] = block
  end

  private
  def parse_options
    lines = @source.split(/\n/)
    @source = lines.reject do |line|
      if line =~ /^@([a-z-]+)$/
        set_option $1
        true
      end
    end.join("\n")
  end

  private
  def set_option(key)
    instance_eval &@@options[key.to_sym]
  end

  private
  def filtered_example
    run_filter_hook(:filter_example, @source)
  end

  private
  def display_source
    code = @source.strip
    code = ERB::Util.html_escape(code).gsub(/&quot;/, '"')
    code = ::MiniSyntax.highlight(code, :html)
    code = set_highlights(code)
    %Q(<pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">#{code}</code></pre>)
  end

  private
  def set_highlights(code)
    code = code.gsub(/^\s*\*\*\*\n(.+?)\n\s*\*\*\*(\n|$)/m, %Q(<strong class="livingstyleguide--code-highlight-block">\\1</strong>))
    code = code.gsub(/\*\*\*(.+?)\*\*\*/, %Q(<strong class="livingstyleguide--code-highlight">\\1</strong>))
  end

  private
  def remove_highlight_markers(code)
    code.gsub(/\*\*\*(.+?)\*\*\*/m, '\\1')
  end

  private
  def run_filter_hook(name, source)
    _hooks[name].each do |callback|
      if callback.kind_of?(Symbol)
        source = send(callback, source)
      else
        source = instance_exec(source, &callback)
      end
    end
    source
  end

end

