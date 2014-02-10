# encoding: utf-8

require 'example_test_helper'

class ColorsTest < ExampleTestCase

  def test_colors_of_file
    LivingStyleGuide::VariablesImporter.stub :variables, %w(red blue) do
      assert_render_equals <<-INPUT, <<-OUTPUT
        @colors variables/colors
      INPUT
        <ul class="livingstyleguide--color-swatches">
          <li class="livingstyleguide--color-swatch $red">$red</li>
          <li class="livingstyleguide--color-swatch $blue">$blue</li>
        </ul>
      OUTPUT
    end
  end

end

