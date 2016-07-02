require "document_test_helper"

class BeforeTest < DocumentTestCase

  def test_before
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @before:
        <h1>This my before</h1>
    INPUT
      <section class="lsg-before">.*<h1>This my before</h1>.*</section>
    OUTPUT
  end

end
