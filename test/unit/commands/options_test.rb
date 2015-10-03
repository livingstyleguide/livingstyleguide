require "document_test_helper"

class OptionsTest < DocumentTestCase

  def test_true
    doc = LivingStyleGuide::Document.new do
      "@set test: true"
    end
    doc.render
    assert_equal doc.options[:test], true
  end

  def test_false
    doc = LivingStyleGuide::Document.new do
      "@set test: false"
    end
    doc.render
    assert_equal doc.options[:test], false
  end

  def test_number
    doc = LivingStyleGuide::Document.new do
      "@set test: 4711"
    end
    doc.render
    assert_equal doc.options[:test], 4711
  end

  def test_string
    doc = LivingStyleGuide::Document.new do
      "@set test: lorem"
    end
    doc.render
    assert_equal doc.options[:test], "lorem"
  end

end
