# encoding: utf-8

require 'example_test_helper'

class ColorsTest < ExampleTestCase

  def test_colors_of_file
    engine = OpenStruct.new(variables: { 'variables/colors' => %w(red blue) })
    assert_render_equals <<-INPUT, <<-OUTPUT, {}, engine
      @colors variables/colors
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-2-columns">
        <li class="livingstyleguide--color-swatch $red">$red</li>
        <li class="livingstyleguide--color-swatch $blue">$blue</li>
      </ul>
    OUTPUT
  end

  def test_defined_colors
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors
      $my-orange $my_green
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-2-columns">
        <li class="livingstyleguide--color-swatch $my-orange">$my-orange</li>
        <li class="livingstyleguide--color-swatch $my-green">$my_green</li>
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

  def test_skipped_cells
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors
      $pink $purple
      -     $turquoise
    INPUT
      <ul class="livingstyleguide--color-swatches -lsg-2-columns">
        <li class="livingstyleguide--color-swatch $pink">$pink</li>
        <li class="livingstyleguide--color-swatch $purple">$purple</li>
        <li class="livingstyleguide--color-swatch -lsg-empty">-</li>
        <li class="livingstyleguide--color-swatch $turquoise">$turquoise</li>
      </ul>
    OUTPUT
  end

end

