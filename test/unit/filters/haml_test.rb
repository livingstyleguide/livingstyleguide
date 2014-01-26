require 'test_helper'

class HamlTest < ExampleTestCase

  def test_haml
    assert_render_match <<-INPUT, <<-OUTPUT
      @haml
      %div
        .lorem Ipsum
    INPUT
      <div class="livingstyleguide--example"> <div> <div class="lorem">Ipsum</div> </div> </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <em>%div</em> <b>.lorem</b> Ipsum</code>
      </pre>
    OUTPUT
  end

end

