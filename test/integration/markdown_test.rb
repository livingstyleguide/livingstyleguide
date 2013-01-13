require 'test_helper'
require 'tilt'

class MarkdownTest < Test::Unit::TestCase

  def render(file)
    template = Tilt.new(file)
    template.render
  end

  def assert_markdown(expected, file)
    expected = expected.gsub(/\s+/m, ' ').gsub('$', '\\$').strip
    given    = render(File.join(%W(test fixtures markdown #{file})))
    given    = given.gsub(/\s+/m, ' ').strip
    assert_match /#{expected}/, given
  end

  def test_examples
    assert_markdown <<-HTML, 'example.md'
      <div class="livingstyleguide--example">
        <button class="button">Test</button>
      </div>
    HTML
  end

  def test_text
    assert_markdown <<-HTML, 'text.md'
      <h2 class="livingstyleguide--headline">Hello World</h2>
      <p class="livingstyleguide--paragraph">Lorem ipsum <strong>dolor</strong> sit amet, <code class="livingstyleguide--code">&lt;consectetur&gt; adipiscing</code> elit. Sed a pulvinar turpis.</p>
      <ul class="livingstyleguide--unordered-list">
        <li class="livingstyleguide--unordered-list-item">Lorem</li>
        <li class="livingstyleguide--unordered-list-item">Ipsum</li>
        <li class="livingstyleguide--unordered-list-item">Dolor</li>
      </ul>
      <h3 class="livingstyleguide--sub-headline">More Lorem</h3>
      <ol class="livingstyleguide--ordered-list">
        <li class="livingstyleguide--ordered-list-item">Lorem</li>
        <li class="livingstyleguide--ordered-list-item">Ipsum</li>
        <li class="livingstyleguide--ordered-list-item">Dolor</li>
      </ol>
    HTML
  end

  def test_code
    assert_markdown <<-HTML, 'code.md'
      <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code"><b><i>.my-class</i></b> {
        <b>color:</b> <b>red</b>;
      }</code></pre>
    HTML
  end

  def test_variables
    assert_markdown <<-HTML, 'variables.md'
      <ul class="livingstyleguide--color-swatches">
        <li class="livingstyleguide--color-swatch $blue">$blue</li>
        <li class="livingstyleguide--color-swatch $green">$green</li>
      </ul>
    HTML
  end

end
