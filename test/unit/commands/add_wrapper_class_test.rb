require "document_test_helper"

class AddWrapperClassTest < DocumentTestCase

  def test_add_wrapper_class
    assert_render_match <<-INPUT, <<-OUTPUT
      ```
      @add-wrapper-class my-class
      ```
    INPUT
      class="lsg-example.+?my-class"
    OUTPUT
  end

end
