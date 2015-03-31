require 'document_test_helper'

class CoffeeScriptTest < DocumentTestCase

  def test_coffee_script
    assert_render_equals <<-INPUT, <<-OUTPUT
      @coffee-script
      alert "Hello world!"
    INPUT
      <section class="livingstyleguide--example livingstyleguide--coffee-example" id="section-9de304"> <script>(function() { alert(\"Hello world!\"); }).call(this); </script>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">alert "Hello world!"<br> </code>
      </pre> </section>
    OUTPUT
  end

  def test_coffee
    assert_render_equals <<-INPUT, <<-OUTPUT
      @coffee
      alert "Hello world!"
    INPUT
      <section class="livingstyleguide--example livingstyleguide--coffee-example" id="section-1791e9"> <script>(function() { alert(\"Hello world!\"); }).call(this); </script>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">alert "Hello world!"<br> </code>
      </pre> </section>
    OUTPUT
  end

end
