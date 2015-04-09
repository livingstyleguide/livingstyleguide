require 'document_test_helper'

class CssTest < DocumentTestCase

  def test_importing_file
    assert_render_match <<-INPUT, '\A\s*\Z'
      @css test/fixtures/import/test.scss
    INPUT
    assert_match(%r(@import "test/fixtures/import/test.scss";), @doc.scss)
  end

  def test_adding_scss
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @css {
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
        @css {
          #adding-scss {
            background: red;
          }
        }
        ```
        @css {
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


