require 'example_test_helper'

class CoffeeScriptTest < ExampleTestCase

  def test_coffee_script
    assert_render_equals <<-INPUT, <<-OUTPUT
      @coffee-script
      alert "Hello world!"
    INPUT
      <div class="livingstyleguide--example -lsg-for-javascript"> <script>(function() { alert("Hello world!"); }).call(this); </script> </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">alert "Hello world!"</code>
      </pre>
    OUTPUT
  end

end


