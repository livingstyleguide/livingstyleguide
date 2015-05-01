require 'document_test_helper'

class HtmlHeadTest < DocumentTestCase

  def test_title
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @title My beautiful style guide
    INPUT
      <head>.*<title>My beautiful style guide</title>.*</head>
    OUTPUT
  end

  def test_head
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @head:
      <link>

      @head:
      <meta>
    INPUT
      <head>.*<link>.*<meta>.*</head>
    OUTPUT
  end

  def test_header
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @header:
      My

      @header:
      Header
    INPUT
      <body.*My.*Header.*</body>
    OUTPUT
  end

  def test_footer
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @footer:
      My

      @footer:
      Footer
    INPUT
      <body.*My.*Footer.*</body>
    OUTPUT
  end

end
