require "document_test_helper"

class RequireTest < DocumentTestCase

  def test_require_custom_ruby_file
    assert_render_match <<-INPUT, <<-OUTPUT, template: "default"
      @require fixtures/commands/custom_command
      @custom-command
    INPUT
      My Custom Command
    OUTPUT
  end

end
