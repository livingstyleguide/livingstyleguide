require "document_test_helper"

class ToggleCode < DocumentTestCase
  def test_toggle_code
    assert_render_equal <<-INPUT, <<-OUTPUT, template: "toggle-code"
      @toggle-code
    INPUT
      <button class="lsg-code-switch" type="button"></button>
    OUTPUT
  end

  def test_toggle_code_include_before
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @toggle-code
    INPUT
      <section class="lsg-before">
        <button class="lsg-code-switch" type="button"></button>
      </section>
    OUTPUT
  end
end
