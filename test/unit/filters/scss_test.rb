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
    assert_match(/##{doc.id} #adding-scss\s*\{\s*background: red;\s*\}/m, doc.css)
  end

  def test_adding_scss_inside_examples
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @scss {
          #adding-scss {
            background: red;
          }
        }
        ```
        @scss {
          #adding-more-scss {
            background: green;
          }
        }
        ```
      INPUT
    end
    doc.render
    assert_match(/##{doc.id} #adding-scss\s*\{\s*background: red;\s*\}/m, doc.css)
    assert_match(/#section-\w{6} #adding-more-scss\s*\{\s*background: green;\s*\}/m, doc.css)
  end

end


