require 'test_helper'
require 'active_support/core_ext/string/inflections'

class ExampleTest < Test::Unit::TestCase
  def test_default
    assert_render <<-INPUT, <<-OUTPUT
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> <button>Hello World</button> </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt</b>
        </code>
      </pre>
    OUTPUT
  end

  private
  def assert_render(input, expected_output)
    output = LivingStyleGuide::Example.new(normalize(input)).render
    assert_equal(normalize(expected_output), normalize(output))
  end
end

