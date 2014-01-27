require 'test_helper'

class AddWrapperClassTest < ExampleTestCase

  def test_add_wrapper_class
    assert_render_match <<-INPUT, <<-OUTPUT
      @add-wrapper-class my-class
      <section>Something wide</section>
    INPUT
      <div class="livingstyleguide--example my-class">
    OUTPUT
  end

end

