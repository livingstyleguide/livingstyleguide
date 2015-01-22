require 'test_helper'

class DocumentTestCase < Minitest::Test

  def setup
    @class = Class.new(LivingStyleGuide::Document)
  end

  def assert_render_equals(input, expected_output, type = :markdown)
    output = @class.new(input.unindent, type).render
    assert_equal(normalize(expected_output), normalize(output))
  end

  def assert_render_match(input, expected_output, type = :markdown)
    output = @class.new(input.unindent, type).render
    assert_match(/#{normalize(expected_output)}/, normalize(output))
  end

end
