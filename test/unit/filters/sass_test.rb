require "document_test_helper"

class CssTest < DocumentTestCase

  def test_importing_sass_file
    assert_render_match <<-INPUT, '\A\s*\Z'
      @sass test/fixtures/import/test
    INPUT
    assert_match(%r(@import "test/fixtures/import/test";), @doc.scss)
  end

  def test_importing_scss_file
    assert_render_match <<-INPUT, '\A\s*\Z'
      @scss test/fixtures/import/test
    INPUT
    assert_match(%r(@import "test/fixtures/import/test";), @doc.scss)
  end

  def test_adding_scss
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @scss {
          #adding-scss {
            background: red;
            #x { color: green; }
          }
        }
      INPUT
    end
    doc.render
    assert_match(Regexp.new(<<-CSS, Regexp::EXTENDED), doc.css)
      ##{doc.id} #adding-scss \{ background: red; \}
      ##{doc.id} #adding-scss #x \{ color: green; \}
    CSS
  end

  def test_adding_sass
    doc = LivingStyleGuide::Document.new do <<-INPUT.unindent
        @sass preprocessor: sass
          #adding-sass
            background: blue
            #x
              background: yellow
      INPUT
    end
    doc.render
    assert_match(Regexp.new(<<-CSS, Regexp::EXTENDED), doc.css)
      ##{doc.id} #adding-sass \{ background: red; \}
      ##{doc.id} #adding-sass #x \{ color: green; \}
    CSS
  end

  def test_adding_css_inside_examples
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
    assert_match(Regexp.new(<<-CSS, Regexp::EXTENDED), doc.css)
      ##{doc.id} #adding-sass \{ background: red; \}
      #section-\w{6} #adding-more-css \{ background: green; \}
    CSS
  end

end
