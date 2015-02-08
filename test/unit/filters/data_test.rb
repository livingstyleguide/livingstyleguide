require 'document_test_helper'

class DataTest < DocumentTestCase

  def test_data_for_erb
    assert_render_match <<-INPUT, <<-OUTPUT, type: :erb
      @data {
        "data_foo": "Bar"
      }
      <div><%= data_foo %></div>
    INPUT
      <div>Bar</div>
    OUTPUT
  end

  def test_data_for_haml
    assert_render_match <<-INPUT, <<-OUTPUT
      @data {
        "data_foo": "Bar"
      }
      @haml
      %div= data_foo
    INPUT
      <div>Bar</div>
    OUTPUT
  end

end
