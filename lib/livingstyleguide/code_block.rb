require 'minisyntax'
require 'erb'
require 'hooks'

class LivingStyleGuide::CodeBlock
  include Hooks
  include Hooks::InstanceHooks
  include LivingStyleGuide::FilterHooks
  define_hook :filter_code

  attr_accessor :source, :language

  def initialize(source, language = nil)
    @source = source
    @language = language
  end

  def render
    code = @source.strip
    code = ERB::Util.html_escape(code).gsub(/&quot;/, '"')
    code = ::MiniSyntax.highlight(code, @language) if @language
    code = run_filter_hook(:filter_code, code)
    %Q(<pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">#{code}</code></pre>)
  end

end

