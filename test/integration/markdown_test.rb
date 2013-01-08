require 'test_helper'
require 'tilt'

class MarkdownTest < Test::Unit::TestCase

  def render(file)
    template = Tilt.new(file)
    html     = template.render
    format_html(html)
  end

  def format_html(html)
    html.gsub! /\n+/, "\n      "
    %Q(      #{html}\n)
  end

  def test_examples
    html = render('test/fixtures/markdown/example.md')
    assert_equal <<-HTML, html
      <div class="livingstyleguide--example">
        <button class="button">Test</button>
      </div>
    HTML
  end

end
