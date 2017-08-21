# encoding: utf-8

require "document_test_helper"

class FontExampleTest < DocumentTestCase

  def test_default_font_example
    assert_render_equal <<-INPUT, <<-OUTPUT
      @font-example 42px Comic Sans, sans-serif
    INPUT
      <div class="lsg-font-example">
        <p class="lsg-font-example-text" style="font: 42px Comic Sans, sans-serif">
          Aa<br>
          ABCDEFGHIJKLMNOPQRSTUVWXYZ<br>
          abcdefghijklmnopqrstuvwxyz<br>
          0123456789 ! ? &amp; / ( ) € $ £ ¥ ¢ = @ ; : , .
        </p>
        <pre class="lsg-code-block">
          <code class="lsg-code">42px Comic Sans, sans-serif</code>
        </pre>
      </div>
    OUTPUT
  end

  def test_font_example_with_quotation_marks
    assert_render_equal <<-INPUT, <<-OUTPUT
      @font-example 42px "Comic Neue"
    INPUT
      <div class="lsg-font-example">
        <p class="lsg-font-example-text" style="font: 42px &quot;Comic Neue&quot;">
          Aa<br>
          ABCDEFGHIJKLMNOPQRSTUVWXYZ<br>
          abcdefghijklmnopqrstuvwxyz<br>
          0123456789 ! ? &amp; / ( ) € $ £ ¥ ¢ = @ ; : , .
        </p>
        <pre class="lsg-code-block">
          <code class="lsg-code">42px &quot;Comic Neue&quot;</code>
        </pre>
      </div>
    OUTPUT
  end

  def test_default_font_example_with_custom_text
    assert_render_equal <<-INPUT, <<-OUTPUT
      @font-example 14px Helvetica {
        Schweißgequält zündet Typograf Jakob
        verflixt öde Pangramme an.
      }
    INPUT
      <div class="lsg-font-example">
        <p class="lsg-font-example-text" style="font: 14px Helvetica">
          Schweißgequält zündet Typograf Jakob<br>
          verflixt öde Pangramme an.
        </p>
        <pre class="lsg-code-block">
          <code class="lsg-code">14px Helvetica</code>
        </pre>
      </div>
    OUTPUT
  end

  def test_default_font_example_with_defaut_custom_text
    backup = LivingStyleGuide.default_options[:font_example]
    LivingStyleGuide.default_options[:font_example] = { text: "zażółć\ngęślą\njaźń" }
    assert_render_equal <<-INPUT, <<-OUTPUT
      @font-example 72px Drogowskaz
    INPUT
      <div class="lsg-font-example">
        <p class="lsg-font-example-text" style="font: 72px Drogowskaz">
          zażółć<br>
          gęślą<br>
          jaźń
        </p>
        <pre class="lsg-code-block">
          <code class="lsg-code">72px Drogowskaz</code>
        </pre>
      </div>
    OUTPUT
    LivingStyleGuide.default_options[:font_example] = backup
  end

end
