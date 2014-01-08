require 'test_helper'
require 'tilt'

class MarkdownTest < Test::Unit::TestCase

  def test_standalone_project
    html = render('test/fixtures/standalone/styleguide.html.lsg')
    assert_match %r(background: red), html
    assert_match %r(<button class="button">), html
    assert_match %r(<title>My Nice &amp; Beautiful Living Style Guide</title>), html
  end

  def test_custom_styles
    html = render('test/fixtures/standalone/styleguide-with-style.html.lsg')
    assert_match %r(.livingstyleguide--ordered-list { color: red;), html
    assert_match %r(border-radius: 3px), html
    assert_match %r(em { color: green;), html
  end

  def test_additional_scss_code
    html = render('test/fixtures/standalone/styleguide-with-scss.html.lsg')
    assert_match %r(#test { color: red; }), html
  end

  def test_additional_sass_code
    html = render('test/fixtures/standalone/styleguide-with-sass.html.lsg')
    assert_match %r(#test { color: green; }), html
  end

  private
  def render(file)
    Tilt.new(file).render.gsub(/\s+/, ' ')
  end

end

