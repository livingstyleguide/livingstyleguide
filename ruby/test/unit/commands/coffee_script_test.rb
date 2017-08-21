require "document_test_helper"

class CoffeeScriptTest < DocumentTestCase

  def test_coffee_script
    assert_render_equal <<-INPUT, <<-OUTPUT
      @coffee-script
      alert "Hello world!"
    INPUT
      <section class="lsg-example lsg-coffee-example" id="section-9de304"> <script>(function() { alert(\"Hello world!\"); }).call(this); </script>
      <pre class="lsg-code-block">
        <code class="lsg-code">alert "Hello world!"</code>
      </pre> </section>
    OUTPUT
  end

  def test_coffee
    assert_render_equal <<-INPUT, <<-OUTPUT
      @coffee
      alert "Hello world!"
    INPUT
      <section class="lsg-example lsg-coffee-example" id="section-1791e9"> <script>(function() { alert(\"Hello world!\"); }).call(this); </script>
      <pre class="lsg-code-block">
        <code class="lsg-code">alert "Hello world!"</code>
      </pre> </section>
    OUTPUT
  end

end
