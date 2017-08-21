require "document_test_helper"

class OptionsTest < DocumentTestCase

  def test_style
    doc = LivingStyleGuide::Document.new do
      "@style font-family: comic sans ms, serif"
    end
    doc.render
    assert_match /\$lsg-font-family: comic sans ms, serif;/, doc.scss
  end

end
