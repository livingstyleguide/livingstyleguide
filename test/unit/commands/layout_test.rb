require "document_test_helper"

class HtmlHeadTest < DocumentTestCase

  def test_title
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @title My beautiful style guide
    INPUT
      <head>.*<title>My beautiful style guide</title>.*</head>
    OUTPUT
  end

  def test_head
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @head:
      <link>

      @head type: haml:
      %meta
    INPUT
      <head>.*<link>.*<meta>.*</head>
    OUTPUT
  end

  def test_header
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @header:
      <span>My</span>

      @header type: haml:
      %b Header
    INPUT
      <body.*<span>My</span>.*<b>Header</b>.*</body>
    OUTPUT
  end

  def test_footer
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @footer:
      <span>My</span>

      @footer type: haml:
      %b Footer
    INPUT
      <body.*<span>My</span>.*<b>Footer</b>..*</body>
    OUTPUT
  end

  def test_javascript_before
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @javascript-before application.js
      @javascript-before {
        alert("Hello World!");
      }
      @javascript-before transpiler: coffee-script
        alert "Hello Coffee World!"
    INPUT
      <head>.*<script src="application.js"><\/script> <script> alert\\("Hello World!"\\); <\/script> <script>.+alert\\("Hello Coffee World!"\\);.*<\/script>.*</head>
    OUTPUT
  end

  def test_javascript_after
    assert_render_match <<-INPUT, <<-OUTPUT, template: "layout"
      @javascript-after application.js
      @javascript-after {
        alert("Good Bye World!");
      }
      @javascript-after transpiler: coffee-script
        alert "Good Bye Coffee World!"
    INPUT
      <body.*<script src="application.js"><\/script> <script> alert\\("Good Bye World!"\\); <\/script> <script>.+alert\\("Good Bye Coffee World!"\\);.*<\/script>.*</body>
    OUTPUT
  end

end
