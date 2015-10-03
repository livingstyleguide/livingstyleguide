require "document_test_helper"

class HamlTest < DocumentTestCase

  def test_haml
    assert_render_match <<-INPUT, <<-OUTPUT
      @haml
      %div
        .lorem Ipsum
    INPUT
      <div> <div class='lorem'>Ipsum</div> </div>
    OUTPUT
  end

end
