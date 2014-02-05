require 'minisyntax'
require 'erb'

class LivingStyleGuide::CodeBlock
  attr_accessor :source, :language

  def initialize(source, language = nil)
    @source = source
    @language = language
  end

  def render
    code = @source.strip
    code = ERB::Util.html_escape(code).gsub(/&quot;/, '"')
    code = ::MiniSyntax.highlight(code, @language) if @language
    %Q(<pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">#{code}</code></pre>)
  end

end

