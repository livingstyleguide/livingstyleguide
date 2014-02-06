require 'minisyntax'
require 'erb'
require 'hooks'

class LivingStyleGuide::CodeBlock
  include Hooks
  include Hooks::InstanceHooks
  include LivingStyleGuide::FilterHooks
  define_hooks :filter_code, :syntax_highlight

  attr_accessor :source, :language

  syntax_highlight do |code|
    if language.nil?
      code
    else
      ::MiniSyntax.highlight(code, language)
    end
  end

  def initialize(source, language = nil)
    @source = source
    @language = language
  end

  def render
    code = @source.strip
    code = ERB::Util.html_escape(code).gsub(/&quot;/, '"')
    code = run_last_filter_hook(:syntax_highlight, code)
    code = run_filter_hook(:filter_code, code)
    %Q(<pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">#{code}</code></pre>)
  end

end

