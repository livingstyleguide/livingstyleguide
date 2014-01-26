require 'minisyntax'
require 'erb'

class LivingStyleGuide::Example

  def initialize(input)
    @source = input
  end

  def render
    %Q(<div class="livingstyleguide--example">\n  #{html_source}\n</div>) + "\n" + display_source
  end

  private
  def html_source
    @source.gsub(/\*\*\*(.+?)\*\*\*/m, '\\1')
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

end

