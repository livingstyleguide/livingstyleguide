require 'test_helper'
require 'tilt'

class MarkdownTest < Minitest::Test

  def render_markdown(file, options)
    engine = LivingStyleGuide::Engine.new(options, {})
    engine.markdown = File.read(file)
    engine.html
  end

  def assert_markdown(expected, file, options = {})
    expected = expected.gsub(/\s+/m, ' ').gsub(/([\$\(\)\[\]])/) { |s| "\\#{s}" }.strip
    given    = render_markdown(File.join(%W(test fixtures markdown #{file})), options)
    given    = given.gsub(/\s+/m, ' ').strip
    assert_match /#{expected}/, given
  end

  def test_examples
    assert_markdown <<-HTML, 'example.md'
      <div class="livingstyleguide--example">
        <button class="button">Test</button>
      </div>
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">.+button.+Test.+button.+</code></pre>
    HTML
  end

  def test_full_width_examples
    assert_markdown <<-HTML, 'full-width-example.md'
      <div class="livingstyleguide--example -lsg-has-full-width">
        <button class="button">Test</button>
      </div>
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">.+button.+Test.+button.+</code></pre>
    HTML
  end

  def test_haml_example
    assert_markdown <<-HTML, 'haml-example.md'
      <div class="livingstyleguide--example">
        <button class="button">Test</button>
      </div>
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code"><em>%button</em><b>.button</b> Test</code></pre>
    HTML
  end

  def test_haml_example_with_highlight
    assert_markdown <<-HTML, 'haml-example-with-highlight.md'
      <div class="livingstyleguide--example">
        <button class="button">Test</button>
      </div>
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code"><em>%button</em><strong class="livingstyleguide--code-highlight">.button</strong> Test</code></pre>
    HTML
  end

  def test_text
    assert_markdown <<-HTML, 'text.md'
      <h2 class="livingstyleguide--headline" id="hello-world"><a class="livingstyleguide--anchor" href="#hello-world"></a>Hello World</h2>
      <p class="livingstyleguide--paragraph">Lorem ipsum <strong>dolor</strong> sit amet,
        <code class="livingstyleguide--code-span livingstyleguide--code">&lt;consectetur&gt; adipiscing</code> elit.
        Sed a pulvinar turpis.</p>
      <ul class="livingstyleguide--unordered-list">
        <li class="livingstyleguide--unordered-list-item">Lorem</li>
        <li class="livingstyleguide--unordered-list-item">Ipsum</li>
        <li class="livingstyleguide--unordered-list-item">Dolor</li>
      </ul>
      <h3 class="livingstyleguide--sub-headline" id="more-lorem"><a class="livingstyleguide--anchor" href="#more-lorem"></a>More Lorem</h3>
      <ol class="livingstyleguide--ordered-list">
        <li class="livingstyleguide--ordered-list-item">Lorem</li>
        <li class="livingstyleguide--ordered-list-item">Ipsum</li>
        <li class="livingstyleguide--ordered-list-item">Dolor</li>
      </ol>
      <h4 class="livingstyleguide--sub-sub-headline" id="even-more-lorem"><a class="livingstyleguide--anchor" href="#even-more-lorem"></a>Even More Lorem</h4>
    HTML
  end

  def test_code
    assert_markdown <<-HTML, 'code.md'
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code"><b><i>.my-class</i></b> {
        <b>color:</b> <b>red</b>;
      }</code></pre>
    HTML
  end

  def test_code_with_highlight
    assert_markdown <<-HTML, 'code-with-highlight.md'
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">.+<strong class="livingstyleguide--code-highlight">example</strong>.+</code></pre>
    HTML
  end

  def test_code_with_highlight_block
    assert_markdown <<-HTML, 'code-with-highlight-block.md'
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">.+<strong class="livingstyleguide--code-highlight-block">.+Block example.+</strong>.+</code></pre>
    HTML
  end

  def test_example_with_highlight
    assert_markdown <<-HTML, 'example-with-highlight.md'
      <div class="livingstyleguide--example">
        <img class="inline example">
        <img class="inline ex-1 ex-2">
      </div>
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">.+<strong class="livingstyleguide--code-highlight">example</strong>.+
      <strong class="livingstyleguide--code-highlight">ex-1</strong> <strong class="livingstyleguide--code-highlight">ex-2</strong>.+</code></pre>
    HTML
  end

  def test_variables
    assert_markdown <<-HTML, 'variables.md'
      <ul class="livingstyleguide--color-swatches -lsg-2-columns">
        <li class="livingstyleguide--color-swatch $blue">$blue</li>
        <li class="livingstyleguide--color-swatch $green">$green</li>
      </ul>
    HTML
  end

  def test_font_example
    assert_markdown <<-HTML, 'font-example.md'
      <div class="livingstyleguide--font-example" style="font: 16px Courier">
        ABCDEFGHIJKLMNOPQRSTUVWXYZ<br>
        abcdefghijklmnopqrstuvwxyz<br>
        0123456789<br>
        !&amp;/()$=@;:,.
      </div>
    HTML
  end

  def test_resetting_language
    assert_markdown <<-HTML, 'code-block-and-example.md', default_language: 'code'
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">Normal code block</code></pre><div class="livingstyleguide--example">
        Example
      </div>
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">Example</code></pre>
    HTML
  end

end
