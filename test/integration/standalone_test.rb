require 'test_helper'
require 'tilt'

class MarkdownTest < Minitest::Test

  def test_standalone_project
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide.html.lsg')
    assert_match %r(background: red), html
    assert_match %r(<button class="button">), html
    assert_match %r(<title>My Nice &amp; Beautiful Living Style Guide</title>), html
  end

  def test_default_source
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/style.html.lsg')
    assert_match %r(background: red), html
    assert_match %r(<button class="button">), html
  end

  def test_custom_styles
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide-with-style.html.lsg')
    assert_match %r(.lsg--ordered-list { color: red;), html
    assert_match %r(border-radius: 3px), html
    assert_match %r(em { color: green;), html
  end

  def test_javascript_includes
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide-with-javascript.html.lsg')
    assert_match %r(<script src="modernizr.js"></script> <script>alert\("Hello World!"\)</script>.*</head>), html
    assert_match %r(<script src="http://code.jquery.com/jquery-2.0.3.js"></script> <script src="application.js"></script> <script>alert\("Goodbye World!"\)</script>.*</body>), html
  end

  def test_additional_scss_code
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide-with-scss.html.lsg')
    assert_match %r(#test { color: red; }), html
  end

  def test_additional_sass_code
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide-with-sass.html.lsg')
    assert_match %r(#test { color: green; }), html
  end

  def test_header_footer
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide-with-header-footer.html.lsg')
    assert_match %r(<h1>Super Style Guide</h1>), html
    assert_match %r(<p>Made by me</p>), html
  end

  def test_json
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide-as-json.html.lsg')
    assert_match %r(<title>My Nice &amp; Beautiful Living Style Guide</title>), html
    assert_match %r(<script src="modernizr.js"></script>.*</head>), html
    assert_match %r(<script src="http://code.jquery.com/jquery-2.0.3.js"></script> <script src="application.js"></script> </body>), html
    assert_match %r(<h1>Super Style Guide</h1>), html
    assert_match %r(<p>Made by me</p>), html
  end

  def test_variables
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide.html.lsg')
    assert_match %r(\.\\\$my-base-color), html
  end

  def test_variables
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide.html.lsg')
    assert_match %r(\.\\\$my-base-color), html
  end

  def test_variables_and_maps
    skip "need rewrite of fixtures"
    if Sass.version[:major] == 3 and Sass.version[:minor] < 3
      skip('This test needs Sass ~> 3.3')
    end
    html = render('test/fixtures/standalone/styleguide-sass-maps.html.lsg')
    assert_match %r(\.\\\$some-map), html
  end

  def test_duplicate_imports_rendered_once
    skip "need rewrite of fixtures"
    html = render('test/fixtures/standalone/styleguide-dup-imports.html.lsg')
    assert_equal 1, html.scan(%r(<h2 class="lsg--headline" id="buttons")).size
  end

  private
  def render(file)
    Tilt.new(file).render.gsub(/\s+/, ' ')
  end

end
