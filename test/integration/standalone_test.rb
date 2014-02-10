require 'test_helper'
require 'tilt'

class MarkdownTest < Minitest::Test

  def test_standalone_project
    html = render('test/fixtures/standalone/styleguide.html.lsg')
    assert_match %r(background: red), html
    assert_match %r(<button class="button">), html
    assert_match %r(<title>My Nice &amp; Beautiful Living Style Guide</title>), html
  end

  def test_default_source
    html = render('test/fixtures/standalone/style.html.lsg')
    assert_match %r(background: red), html
    assert_match %r(<button class="button">), html
  end

  def test_custom_styles
    html = render('test/fixtures/standalone/styleguide-with-style.html.lsg')
    assert_match %r(.livingstyleguide--ordered-list { color: red;), html
    assert_match %r(border-radius: 3px), html
    assert_match %r(em { color: green;), html
  end

  def test_javascript_includes
    html = render('test/fixtures/standalone/styleguide-with-javascript.html.lsg')
    assert_match %r(<script src="modernizr.js"></script>.*</head>), html
    assert_match %r(<script src="http://code.jquery.com/jquery-2.0.3.js"></script> <script src="application.js"></script> </body>), html
  end

  def test_additional_scss_code
    html = render('test/fixtures/standalone/styleguide-with-scss.html.lsg')
    assert_match %r(#test { color: red; }), html
  end

  def test_additional_sass_code
    html = render('test/fixtures/standalone/styleguide-with-sass.html.lsg')
    assert_match %r(#test { color: green; }), html
  end

  def test_header_footer
    html = render('test/fixtures/standalone/styleguide-with-header-footer.html.lsg')
    assert_match %r(<h1>Super Style Guide</h1>), html
    assert_match %r(<p>Made by me</p>), html
  end

  def test_json
    html = render('test/fixtures/standalone/styleguide-as-json.html.lsg')
    assert_match %r(<title>My Nice &amp; Beautiful Living Style Guide</title>), html
    assert_match %r(<script src="modernizr.js"></script>.*</head>), html
    assert_match %r(<script src="http://code.jquery.com/jquery-2.0.3.js"></script> <script src="application.js"></script> </body>), html
    assert_match %r(<h1>Super Style Guide</h1>), html
    assert_match %r(<p>Made by me</p>), html
  end

  private
  def render(file)
    Tilt.new(file).render.gsub(/\s+/, ' ')
  end

end

