require 'test_helper'

describe LivingStyleGuide::Document do

  it "outputs the input as default" do
    input = "Test"
    doc = LivingStyleGuide::Document.new(input)
    doc.render.must_equal "Test"
  end

  it "outputs the source" do
    input = "Test"
    doc = LivingStyleGuide::Document.new(input)
    doc.source.must_equal "Test"
  end

  it "outputs the input as HTML for Markdown" do
    input = "*Test*"
    doc = LivingStyleGuide::Document.new(input, :markdown)
    doc.render.must_equal "<p><em>Test</em></p>\n"
  end

end
