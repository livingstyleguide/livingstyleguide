require 'test_helper'

describe LivingStyleGuide::CodeBlock do

  before do
    @code_block = Class.new(LivingStyleGuide::CodeBlock)
  end

  describe "when no language is given" do
    it "should output the code" do
      @code_block.new("My Code").render.must_equal <<-HTML.unindent.strip
        <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">My Code</code></pre>
      HTML
    end

    it "should html escape the code" do
      @code_block.new("1 < 2 > 0 &\"").render.must_equal <<-HTML.unindent.strip
        <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">1 &lt; 2 &gt; 0 &amp;"</code></pre>
      HTML
    end
  end

  describe "when a language is given" do
    it "should output the code with syntax highlighting" do
      @code_block.new("<my-code>", :html).render.must_equal <<-HTML.unindent.strip
        <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code"><b>&lt;<em>my-code</em></b><b>&gt;</b></code></pre>
      HTML
    end
  end

  describe "when filters are set" do
    it "should filter the code" do
      @code_block.filter_code do |code|
        code.gsub(/ugly/, 'beautiful')
      end

      @code_block.new("my ugly code").render.must_equal <<-HTML.unindent.strip
        <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">my beautiful code</code></pre>
      HTML
    end
  end
end

