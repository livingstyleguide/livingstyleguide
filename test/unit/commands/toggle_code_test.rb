require "document_test_helper"

class ToggleCode < DocumentTestCase

  def test_toggle_code
    assert_render_equals <<-INPUT, <<-OUTPUT, template: :"toggle-code"
      @toggle-code
    INPUT
      <input type="button" class="lsg--code-switch">
    OUTPUT
  end

  def test_toggle_code_include_before
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @toggle-code
    INPUT
      .*<section class="lsg--before">.*<input type="button" class="lsg--code-switch">.*</section>.*
    OUTPUT
  end

end