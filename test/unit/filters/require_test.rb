require 'document_test_helper'

class RequireTest < DocumentTestCase

  def test_require_custom_ruby_file
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      @require fixtures/filters/custom_filter
      @custom-filter
    INPUT
      My Custom Filter
    OUTPUT
  end

end
