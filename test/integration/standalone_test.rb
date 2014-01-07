require 'test_helper'
require 'tilt'

class MarkdownTest < Test::Unit::TestCase

  def test_standalone_project
    html = Tilt.new('test/fixtures/standalone/styleguide.html.lsg').render
    assert_match %r(background: red), html
    assert_match %r(<button class="button">), html
    assert_match %r(<title>My Nice &amp; Beautiful Living Style Guide</title>), html
  end

end

