# encoding: utf-8

require "document_test_helper"

class ColorsTest < DocumentTestCase

  def test_colors_of_file
    skip
    engine = OpenStruct.new(variables: { "variables/colors" => %w(red blue) })
    assert_render_equals <<-INPUT, <<-OUTPUT, {}, engine
      @colors variables/colors
    INPUT
      <ul class="lsg--color-swatches -lsg-2-columns">
        <li class="lsg--color-swatch $red"><span>$red</span></li>
        <li class="lsg--color-swatch $blue"><span>$blue</span></li>
      </ul>
    OUTPUT
  end

  def test_defined_colors
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors {
        $my-orange $my_green
      }
    INPUT
      <ul class="lsg--color-swatches -lsg-2-columns">
        <li class="lsg--color-swatch $my-orange">$my-orange</li>
        <li class="lsg--color-swatch $my_green">$my_green</li>
      </ul>
    OUTPUT
  end

  def test_rows
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors {
        $pink $purple $gray
        $turquoise $cyan $black
      }
    INPUT
      <ul class="lsg--color-swatches -lsg-3-columns">
        <li class="lsg--color-swatch $pink"><span>$pink</span></li>
        <li class="lsg--color-swatch $purple"><span>$purple</span></li>
        <li class="lsg--color-swatch $gray"><span>$gray</span></li>
        <li class="lsg--color-swatch $turquoise"><span>$turquoise</span></li>
        <li class="lsg--color-swatch $cyan"><span>$cyan</span></li>
        <li class="lsg--color-swatch $black"><span>$black</span></li>
      </ul>
    OUTPUT
  end

  def test_skipped_cells
    assert_render_equals <<-INPUT, <<-OUTPUT
      @colors {
        $pink $purple
        -     $turquoise
      }
    INPUT
      <ul class="lsg--color-swatches -lsg-2-columns">
        <li class="lsg--color-swatch $pink"><span>$pink</span></li>
        <li class="lsg--color-swatch $purple"><span>$purple</span></li>
        <li class="lsg--color-swatch -lsg-empty"><span>-</span></li>
        <li class="lsg--color-swatch $turquoise"><span>$turquoise</span></li>
      </ul>
    OUTPUT
  end

  def test_functions_and_colors
    assert_render_equals <<-INPUT, <<-OUTPUT
      @scss {
        $pink: #c82570 !global;
      }
      @colors {
        $pink purple() #87c53b red
      }
    INPUT
      <ul class="lsg--color-swatches -lsg-4-columns">
        <li class="lsg--color-swatch $pink"><span>$pink</span></li>
        <li class="lsg--color-swatch purple()"><span>purple()</span></li>
        <li class="lsg--color-swatch #87c53b"><span>#87c53b</span></li>
        <li class="lsg--color-swatch red"><span>red</span></li>
      </ul>
    OUTPUT
    assert_match /.\$pink/, @doc.css
    assert_match /.purple\(\)/, @doc.css
    assert_match /.\#87c53b/, @doc.css
    assert_match /.red/, @doc.css
  end

end
