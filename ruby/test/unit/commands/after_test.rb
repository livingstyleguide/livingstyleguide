require "document_test_helper"

class AfterTest < DocumentTestCase

  def test_after
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @after:
        <h1>This my after</h1>
    INPUT
      <section class="lsg-after">.*<h1>This my after</h1>.*</section>
    OUTPUT
  end

end
