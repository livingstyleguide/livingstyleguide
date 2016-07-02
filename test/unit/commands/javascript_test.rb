require "document_test_helper"

class JavaScriptTest < DocumentTestCase

  def test_javascript
    assert_render_equal <<-INPUT, <<-OUTPUT
      @javascript
      alert("Hello world!");
    INPUT
      <section class="lsg-example lsg-javascript-example" id="section-c1ffd7"> <script> alert("Hello world!"); </script>
      <pre class="lsg-code-block">
        <code class="lsg-code">alert(<q>"<b>Hello</b> world!"</q>);</code>
      </pre> </section>
    OUTPUT
  end

end
