require "test_helper"

class DocumentTestCase < Minitest::Test
  def setup
    @class = Class.new(LivingStyleGuide::Document)
  end

  def render(input, options = {})
    @doc = @class.new(options[:file]) do
      input.unindent(ignore_blank: true)
    end
    @doc.type = options[:type] || :lsg
    @doc.template = options[:template] || "plain"
    @doc.render
  end

  def assert_render_equal(input, expected_output, options = {})
    output = render(input, options)
    assert_equal(normalize(expected_output), normalize(output))
  end

  def assert_render_match(input, expected_output, options = {})
    output = render(input, options)
    assert_match(/#{normalize(expected_output)}/, normalize(output))
  end
end
