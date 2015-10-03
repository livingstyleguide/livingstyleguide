require "document_test_helper"

class TypeTest < DocumentTestCase

  def test_erb
    assert_render_match <<-INPUT, <<-OUTPUT
      @type erb
      <div>
        <div class="lorem"><%= "Ipsum" %></div>
      </div>
    INPUT
      <div> <div class="lorem">Ipsum</div> </div>
    OUTPUT
  end

  def test_haml
    assert_render_match <<-INPUT, <<-OUTPUT
      @type haml
      %div
        .lorem Ipsum
    INPUT
      <div> <div class='lorem'>Ipsum</div> </div>
    OUTPUT
  end

  def test_markdown
    assert_render_match <<-INPUT, <<-OUTPUT
      @type markdown
      # Ipsum
      Lorem
    INPUT
      <h1>Ipsum</h1>
      <p>Lorem</p>
    OUTPUT
  end

  def test_unknown_templating_engine
    assert_render_match <<-INPUT, <<-OUTPUT
      @type foo
      >foo<
        "Bar"
      >oof/<
    INPUT
      >foo<
        "Bar"
      >oof/<
    OUTPUT
  end

end
