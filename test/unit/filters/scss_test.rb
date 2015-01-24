require 'example_test_helper'

class JavaScriptTest < ExampleTestCase

  def test_adding_scss
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @scss {
          #adding-scss {
            background: red;
          }
        }
      INPUT
    end
    doc.render
    assert_match(/#adding-scss\s*\{\s*background: red;\s*\}/m, doc.css)
  end

end


