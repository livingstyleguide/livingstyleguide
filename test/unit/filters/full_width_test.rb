require 'example_test_helper'

class FullWidthTest < ExampleTestCase

  def test_full_width
    assert_render_match <<-INPUT, <<-OUTPUT
      @full-width
      <section>Something wide</section>
    INPUT
      <div class="livingstyleguide--example -lsg-has-full-width">
    OUTPUT
  end

end


