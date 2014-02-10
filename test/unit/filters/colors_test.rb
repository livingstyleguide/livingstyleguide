# encoding: utf-8

require 'example_test_helper'

class ColorsTest < ExampleTestCase

  def test_colors_of_file
    LivingStyleGuide::VariablesImporter.stub :variables, %w(red blue) do
      assert_render_equals <<-INPUT, <<-OUTPUT
        @colors variables/colors
      INPUT
        <ul class="livingstyleguide--color-swatches -lsg-2-columns">
          <li class="livingstyleguide--color-swatch $red">$red</li>
          <li class="livingstyleguide--color-swatch $blue">$blue</li>
        </ul>
      OUTPUT
    end
  end

  def test_defined_colors
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors
      $orange $green
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-2-columns">
        <li class="livingstyleguide--color-swatch $orange">$orange</li>
        <li class="livingstyleguide--color-swatch $green">$green</li>
      </ul>
    OUTPUT
  end

  def test_rows
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors
      $pink $purple $gray
      $turquoise $cyan $black
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-3-columns">
        <li class="livingstyleguide--color-swatch $pink">$pink</li>
        <li class="livingstyleguide--color-swatch $purple">$purple</li>
        <li class="livingstyleguide--color-swatch $gray">$gray</li>
        <li class="livingstyleguide--color-swatch $turquoise">$turquoise</li>
        <li class="livingstyleguide--color-swatch $cyan">$cyan</li>
        <li class="livingstyleguide--color-swatch $black">$black</li>
      </ul>
    OUTPUT
  end

end

