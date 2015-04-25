# encoding: utf-8

require 'document_test_helper'

class FontExampleTest < DocumentTestCase

  def test_default_font_example
    assert_render_equals <<-INPUT, <<-OUTPUT
      @font-example 42px Comic Sans, sans-serif
    INPUT
      <div class="livingstyleguide--font-example" style="font: 42px Comic Sans, sans-serif">
        ABCDEFGHIJKLMNOPQRSTUVWXYZ<br>
        abcdefghijklmnopqrstuvwxyz<br>
        0123456789<br>
        !&amp;/()$=@;:,.
      </div>
    OUTPUT
  end

  def test_font_example_with_quotation_marks
    assert_render_equals <<-INPUT, <<-OUTPUT
      @font-example 42px "Comic Neue"
    INPUT
      <div class="livingstyleguide--font-example" style="font: 42px &quot;Comic Neue&quot;">
        ABCDEFGHIJKLMNOPQRSTUVWXYZ<br>
        abcdefghijklmnopqrstuvwxyz<br>
        0123456789<br>
        !&amp;/()$=@;:,.
      </div>
    OUTPUT
  end

  def test_default_font_example_with_custom_text
    assert_render_equals <<-INPUT, <<-OUTPUT
      @font-example 14px Helvetica {
        Schweißgequält zündet Typograf Jakob
        verflixt öde Pangramme an.
      }
    INPUT
      <div class="livingstyleguide--font-example" style="font: 14px Helvetica">
        Schweißgequält zündet Typograf Jakob<br>
        verflixt öde Pangramme an.
      </div>
    OUTPUT
  end

  def test_default_font_example_with_defaut_custom_text
    backup = LivingStyleGuide.default_options[:font_example]
    LivingStyleGuide.default_options[:font_example] = { text: "zażółć\ngęślą\njaźń" }
    assert_render_equals <<-INPUT, <<-OUTPUT
      @font-example 72px Drogowskaz
    INPUT
      <div class="livingstyleguide--font-example" style="font: 72px Drogowskaz">
        zażółć<br>
        gęślą<br>
        jaźń
      </div>
    OUTPUT
    LivingStyleGuide.default_options[:font_example] = backup
  end

end


