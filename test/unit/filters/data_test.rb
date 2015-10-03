require "document_test_helper"

class DataTest < DocumentTestCase

  def test_json_for_erb
    assert_render_match <<-INPUT, <<-OUTPUT, type: :erb
      @data {
        "data_foo": "Bar"
      }
      <div><%= data_foo %></div>
    INPUT
      <div>Bar</div>
    OUTPUT
  end

  def test_json_for_haml
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

  def test_yaml_for_erb
    assert_render_match <<-INPUT, <<-OUTPUT, type: :erb
      @data format: yaml
        data_foo: Bar
      <div><%= data_foo %></div>
    INPUT
      <div>Bar</div>
    OUTPUT
  end

  def test_json_array
    assert_render_match <<-INPUT, <<-OUTPUT, type: :erb
      @data {
        [
          { "data_foo": "Bar" },
          { "data_foo": "Cafe" }
        ]
      }
      <div><%= data_foo %></div>
    INPUT
      <div>Bar</div>
      <div>Cafe</div>
    OUTPUT
  end

  def test_yaml_array
    assert_render_match <<-INPUT, <<-OUTPUT, type: :erb
      @data format: yaml
        - data_foo: Bar
        - data_foo: Cafe
      <div><%= data_foo %></div>
    INPUT
      <div>Bar</div>
      <div>Cafe</div>
    OUTPUT
  end

end
