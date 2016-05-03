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
        <li class="lsg--color-swatch $red"><span class="lsg--color-swatch-source">$red</span><span class="lsg--color-swatch-value $red"></span></li>
        <li class="lsg--color-swatch $blue"><span class="lsg--color-swatch-source">$blue</span><span class="lsg--color-swatch-value $blue"></span></li>
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
        <li class="lsg--color-swatch $my-orange"><span class="lsg--color-swatch-source">$my-orange</span><span class="lsg--color-swatch-value $my-orange"></span></li>
        <li class="lsg--color-swatch $my_green"><span class="lsg--color-swatch-source">$my_green</span><span class="lsg--color-swatch-value $my_green"></span></li>
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
        <li class="lsg--color-swatch $pink"><span class="lsg--color-swatch-source">$pink</span><span class="lsg--color-swatch-value $pink"></span></li>
        <li class="lsg--color-swatch $purple"><span class="lsg--color-swatch-source">$purple</span><span class="lsg--color-swatch-value $purple"></span></li>
        <li class="lsg--color-swatch $gray"><span class="lsg--color-swatch-source">$gray</span><span class="lsg--color-swatch-value $gray"></span></li>
        <li class="lsg--color-swatch $turquoise"><span class="lsg--color-swatch-source">$turquoise</span><span class="lsg--color-swatch-value $turquoise"></span></li>
        <li class="lsg--color-swatch $cyan"><span class="lsg--color-swatch-source">$cyan</span><span class="lsg--color-swatch-value $cyan"></span></li>
        <li class="lsg--color-swatch $black"><span class="lsg--color-swatch-source">$black</span><span class="lsg--color-swatch-value $black"></span></li>
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
        <li class="lsg--color-swatch $pink"><span class="lsg--color-swatch-source">$pink</span><span class="lsg--color-swatch-value $pink"></span></li>
        <li class="lsg--color-swatch $purple"><span class="lsg--color-swatch-source">$purple</span><span class="lsg--color-swatch-value $purple"></span></li>
        <li class="lsg--color-swatch -lsg-empty"></li>
        <li class="lsg--color-swatch $turquoise"><span class="lsg--color-swatch-source">$turquoise</span><span class="lsg--color-swatch-value $turquoise"></span></li>
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
        light($pink) light(purple()) light(#87c53b) light(red)
      }
    INPUT
      <ul class="lsg--color-swatches -lsg-4-columns">
        <li class="lsg--color-swatch $pink"><span class="lsg--color-swatch-source">$pink</span><span class="lsg--color-swatch-value $pink"></span></li>
        <li class="lsg--color-swatch purple()"><span class="lsg--color-swatch-source">purple()</span><span class="lsg--color-swatch-value purple()"></span></li>
        <li class="lsg--color-swatch #87c53b"><span class="lsg--color-swatch-value #87c53b"></span></li>
        <li class="lsg--color-swatch red"><span class="lsg--color-swatch-value red"></span></li>
        <li class="lsg--color-swatch light($pink)"><span class="lsg--color-swatch-source">light($pink)</span><span class="lsg--color-swatch-value light($pink)"></span></li>
        <li class="lsg--color-swatch light(purple())"><span class="lsg--color-swatch-source">light(purple())</span><span class="lsg--color-swatch-value light(purple())"></span></li>
        <li class="lsg--color-swatch light(#87c53b)"><span class="lsg--color-swatch-source">light(#87c53b)</span><span class="lsg--color-swatch-value light(#87c53b)"></span></li>
        <li class="lsg--color-swatch light(red)"><span class="lsg--color-swatch-source">light(red)</span><span class="lsg--color-swatch-value light(red)"></span></li>
      </ul>
    OUTPUT
    assert_match /.\$pink/, @doc.css
    assert_match /.purple\(\)/, @doc.css
    assert_match /.\#87c53b/, @doc.css
    assert_match /.red/, @doc.css
  end

end
