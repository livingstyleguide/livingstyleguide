require 'test_helper'

class JavaScriptTest < ExampleTestCase

  def test_javascript
    assert_render_equals <<-INPUT, <<-OUTPUT
      @javascript
      alert("Hello world!");
    INPUT
      <div class="livingstyleguide--example -lsg-for-javascript"> <script>alert("Hello world!");</script> </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">alert(<q>"<b>Hello</b> world!"</q>);</code>
      </pre>
    OUTPUT
  end

end

