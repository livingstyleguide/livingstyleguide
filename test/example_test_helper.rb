require 'test_helper'

class ExampleTestCase < Minitest::Test

  def setup
    @class = Class.new(LivingStyleGuide::Example)
  end

  def assert_render_equals(input, expected_output, options = {})
    output = @class.new(input.unindent, options).render
    assert_equal(normalize(expected_output), normalize(output))
  end

  def assert_render_match(input, expected_output, options = {})
    output = @class.new(input.unindent, options).render
    assert_match(/#{normalize(expected_output)}/, normalize(output))
  end

end

