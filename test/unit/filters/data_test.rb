require 'document_test_helper'

class DataTest < DocumentTestCase

  def test_data
    assert_render_match <<-INPUT, <<-OUTPUT, type: 'erb'
      @data {
        "foo": "Bar"
      }
      <div><%= foo %></div>
    INPUT
      <div>Bar</div>
    OUTPUT
  end

end
