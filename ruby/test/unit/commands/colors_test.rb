# encoding: utf-8

require "document_test_helper"
require "digest/sha1"

class ColorsTest < DocumentTestCase

  def assert_render_equal_but_ignore_sha(input, expected_output, options = {})
    sources = []
    fake_sha = Proc.new do |source|
      sources << source unless sources.include?(source)
      "HEX#{sources.index(source) + 1}"
    end
    Digest::SHA1.stub(:hexdigest, fake_sha) do
      assert_render_equal(input, expected_output, options)
    end
  end

  def test_defined_colors
    assert_render_equal_but_ignore_sha <<-INPUT, <<-OUTPUT
      @colors {
        $my-orange $my_green
      }
    INPUT
      <ul class="lsg-color-swatches lsg-2-columns">
        <li class="lsg-color-swatch lsg-color-HEX1"><span class="lsg-color-swatch-source">$my-orange</span><span class="lsg-color-swatch-value lsg-color-HEX1"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX2"><span class="lsg-color-swatch-source">$my_green</span><span class="lsg-color-swatch-value lsg-color-HEX2"></span></li>
      </ul>
    OUTPUT
  end

  def test_duplicate_colors
    assert render <<-INPUT, template: "layout"
      @scss !global {
        $my-orange: rgb(228, 168, 79);
      }
      @colors {
        $my-orange $my-orange
      }
    INPUT
  end

  def test_rows
    assert_render_equal_but_ignore_sha <<-INPUT, <<-OUTPUT
      @colors {
        $pink $purple $gray
        $my-color $cyan $black
      }
    INPUT
      <ul class="lsg-color-swatches lsg-3-columns">
        <li class="lsg-color-swatch lsg-color-HEX1"><span class="lsg-color-swatch-source">$pink</span><span class="lsg-color-swatch-value lsg-color-HEX1"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX2"><span class="lsg-color-swatch-source">$purple</span><span class="lsg-color-swatch-value lsg-color-HEX2"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX3"><span class="lsg-color-swatch-source">$gray</span><span class="lsg-color-swatch-value lsg-color-HEX3"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX4"><span class="lsg-color-swatch-source">$my-color</span><span class="lsg-color-swatch-value lsg-color-HEX4"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX5"><span class="lsg-color-swatch-source">$cyan</span><span class="lsg-color-swatch-value lsg-color-HEX5"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX6"><span class="lsg-color-swatch-source">$black</span><span class="lsg-color-swatch-value lsg-color-HEX6"></span></li>
      </ul>
    OUTPUT
  end

  def test_skipped_cells
    assert_render_equal_but_ignore_sha <<-INPUT, <<-OUTPUT
      @colors {
        $pink $purple
        -     $my-color
      }
    INPUT
      <ul class="lsg-color-swatches lsg-2-columns">
        <li class="lsg-color-swatch lsg-color-HEX1"><span class="lsg-color-swatch-source">$pink</span><span class="lsg-color-swatch-value lsg-color-HEX1"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX2"><span class="lsg-color-swatch-source">$purple</span><span class="lsg-color-swatch-value lsg-color-HEX2"></span></li>
        <li class="lsg-color-swatch lsg-empty"></li>
        <li class="lsg-color-swatch lsg-color-HEX3"><span class="lsg-color-swatch-source">$my-color</span><span class="lsg-color-swatch-value lsg-color-HEX3"></span></li>
      </ul>
    OUTPUT
  end

  def test_functions_and_colors
    assert_render_equal_but_ignore_sha <<-INPUT, <<-OUTPUT
      @scss scope: global {
        $pink: #c82570 !global;
        @function light($color) {
          @return change-color($color, $lightness: 90%);
        }
        @function my-color() {
          @return #2ef1bd;
        }
      }
      @colors {
        $pink           my-color()        #87c53b          red
        light($pink)    light(my-color()) light(#87c53b)   light(red)
        rgba(0,0,0,0.5) rgba(red, 0.5)    rgba( red, 0.5 ) -
      }
    INPUT
      <ul class="lsg-color-swatches lsg-4-columns">
        <li class="lsg-color-swatch lsg-color-HEX1"><span class="lsg-color-swatch-source">$pink</span><span class="lsg-color-swatch-value lsg-color-HEX1"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX2"><span class="lsg-color-swatch-source">my-color()</span><span class="lsg-color-swatch-value lsg-color-HEX2"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX3"><span class="lsg-color-swatch-value lsg-color-HEX3"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX4"><span class="lsg-color-swatch-value lsg-color-HEX4"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX5"><span class="lsg-color-swatch-source">light($pink)</span><span class="lsg-color-swatch-value lsg-color-HEX5"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX6"><span class="lsg-color-swatch-source">light(my-color())</span><span class="lsg-color-swatch-value lsg-color-HEX6"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX7"><span class="lsg-color-swatch-source">light(#87c53b)</span><span class="lsg-color-swatch-value lsg-color-HEX7"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX8"><span class="lsg-color-swatch-source">light(red)</span><span class="lsg-color-swatch-value lsg-color-HEX8"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX9"><span class="lsg-color-swatch-source">rgba(0,0,0,0.5)</span><span class="lsg-color-swatch-value lsg-color-HEX9"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX10"><span class="lsg-color-swatch-source">rgba(red, 0.5)</span><span class="lsg-color-swatch-value lsg-color-HEX10"></span></li>
        <li class="lsg-color-swatch lsg-color-HEX11"><span class="lsg-color-swatch-source">rgba( red, 0.5 )</span><span class="lsg-color-swatch-value lsg-color-HEX11"></span></li>
        <li class="lsg-color-swatch lsg-empty"></li>
      </ul>
    OUTPUT
    assert_match /.lsg-color-HEX1/, @doc.css
    assert_match /.lsg-color-HEX11/, @doc.css
  end

end
