require "document_test_helper"

class SyntaxTest < DocumentTestCase

  def test_haml
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @type string
        @syntax html
        <div>Hello World</div>
      INPUT
    end
    doc.render
    assert_match("<b>&lt;<em>div</em></b><b>&gt;</b>Hello World<b>&lt;/<em>div</em>&gt;</b>", doc.highlighted_source)
  end

end
