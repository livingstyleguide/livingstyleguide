require 'test_helper'

describe LivingStyleGuide::Document do

  before do
    @doc = LivingStyleGuide::Document.new('')
  end

  def assert_document_equals(input, output)
    @doc.source = input.gsub(/^      /, '')
    @doc.render.strip.must_equal output.gsub(/^      /, '').strip
  end

  it "outputs the source" do
    doc = LivingStyleGuide::Document.new("Test")
    doc.source.must_equal "Test"
  end

  it "outputs the input as default" do
    assert_document_equals "Test", "Test"
  end

  it "outputs the input as HTML for Markdown" do
    @doc.type = :markdown
    assert_document_equals "*Test*", "<p><em>Test</em></p>"
  end

end
