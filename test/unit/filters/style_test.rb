require 'document_test_helper'

class OptionsTest < DocumentTestCase

  def test_style
    doc = LivingStyleGuide::Document.new do
      "@style base-font: 'comic sans ms', serif"
    end
    doc.render
    assert_match /\$livingstyleguide--base-font: 'comic sans ms', serif;/, doc.scss
  end

end
