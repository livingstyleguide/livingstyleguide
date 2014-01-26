require 'test_helper'
require 'tilt'

class ExamplesTest < Test::Unit::TestCase

  def render(file)
    template = Tilt.new(file)
    template.render
  end

  def assert_markdown(expected, file)
    expected = expected.gsub(/\s+/m, ' ').gsub(/([\$\(\)\[\]])/) { |s| "\\#{s}" }.strip
    given    = render(File.join(%W(test fixtures markdown #{file})))
    given    = given.gsub(/\s+/m, ' ').strip
    assert_match /#{expected}/, given
  end

  def test_examples

  end
end

