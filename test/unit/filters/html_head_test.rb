require 'document_test_helper'

class HtmlHeadTest < DocumentTestCase

  def test_title
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @title My beautiful style guide
    INPUT
      <head>.*<title>My beautiful style guide</title>.*</head>
    OUTPUT
  end

end
