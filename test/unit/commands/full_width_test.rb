require "document_test_helper"

class FullWidthTest < DocumentTestCase

  def test_full_width
    assert_render_match <<-INPUT, <<-OUTPUT
      ```
      @full-width
      ```
    INPUT
      class=".*?lsg-example.+?lsg-has-full-width.*?"
    OUTPUT
  end

end
