require "document_test_helper"

class CssTest < DocumentTestCase

  def test_importing_file
    assert_render_match <<-INPUT, '\A\s*\Z'
      @css test/fixtures/import/test.css
    INPUT
    assert_match("@import url(test/fixtures/import/test.css);", @doc.css)
  end

  def test_adding_css
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @css {
          #adding-css {
            background: red;
          }
          #adding-more-css-with,
          #multiple-selctors {
            color: green;
          }
        }
      INPUT
    end
    doc.render
    assert_match(Regexp.new(<<-CSS, Regexp::EXTENDED), doc.css)
      ##{doc.id} #adding-css \{ background: red; \}
      ##{doc.id} #adding-more-css-with,
      ##{doc.id} #multiple-selctors \{ color: green; \}
    CSS
  end

  def test_adding_global_css
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @css scope: global {
          #adding-global-css {
            background: red;
          }
        }
      INPUT
    end
    doc.render
    assert_match(/(?<!##{doc.id} )#adding-global-css \{/, doc.css)
  end

  def test_adding_css_inside_examples
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @css {
          #adding-css {
            background: red;
          }
        }
        ```
        @css {
          #adding-more-css {
            background: green;
          }
        }
        ```
      INPUT
    end
    doc.render
    assert_match(/##{doc.id} #adding-css\s*\{\s*background: red;\s*\}/m, doc.css)
    assert_match(/#section-\w{6} #adding-more-css\s*\{\s*background: green;\s*\}/m, doc.css)
  end

end
