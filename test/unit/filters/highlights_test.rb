require 'test_helper'

class HightlightsTest < ExampleTestCase

  def test_one_line
    assert_render_match <<-INPUT, <<-OUTPUT
      This is ***highlighted*** text.
    INPUT
      This is <strong class="livingstyleguide--code-highlight">highlighted</strong> text.
    OUTPUT
  end

  def test_multi_line
    assert_render_match <<-INPUT, <<-OUTPUT
      This is
      ***
      highlighted
      ***
      text.
    INPUT
      This is <strong class="livingstyleguide--code-highlight-block">highlighted</strong> text.
    OUTPUT
  end

end

