require "test_helper"

describe LivingStyleGuide::Document do

  def assert_document_equal(input, output, options = {})
    @doc = LivingStyleGuide::Document.new { input.unindent(ignore_blank: true) }
    @doc.type = options[:type] || :lsg
    @doc.template = options[:template] || "plain"
    actual = @doc.render(nil, options[:data]).gsub(/\n+\s*/, " ").strip
    expected = output.gsub(/\n+\s*/, " ").strip
    actual.must_equal expected
  end

  def assert_document_match(input, output, options = {})
    @doc = LivingStyleGuide::Document.new { input.unindent(ignore_blank: true) }
    @doc.type = options[:type] || :lsg
    @doc.template = options[:template] || "plain"
    actual = @doc.render(nil, options[:data]).gsub(/\n+\s*/, " ").strip
    expected = output.gsub(/\n+\s*/, " ").strip
    actual.must_match Regexp.new(expected, Regexp::MULTILINE)
  end

  describe "base features" do

    it "outputs the source" do
      doc = LivingStyleGuide::Document.new { "Test" }
      doc.render
      doc.source.must_equal "Test"
    end

    it "outputs the input as default" do
      assert_document_equal "Test", "Test", type: :plain
    end

    it "outputs the input as HTML for Markdown" do
      assert_document_equal <<-INPUT, <<-OUTPUT
        *Test*
      INPUT
        <p class="lsg-paragraph"><em>Test</em></p>
      OUTPUT
    end

  end

  describe "change type by filter" do

    it "allows to set the type to Markdown" do
      assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
        @markdown
        *Test*
      INPUT
        <p><em>Test</em></p>
      OUTPUT
    end

    it "allows to set the type to Haml" do
      assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
        @haml
        %test Test
      INPUT
        <test>Test</test>
      OUTPUT
    end

  end

  describe "set default type" do

    it "allows to set the default type to Markdown" do
      assert_document_match <<-INPUT, <<-OUTPUT
        @default type: markdown

        ```
        *Test*
        ```
      INPUT
        <p><em>Test</em></p>
      OUTPUT
    end

  end

  describe "filter syntax" do

    describe "filters without blocks" do

      it "can have filters with an argument" do
        LivingStyleGuide.command :my_filter do |arguments, options, block|
          "arg: #{arguments.first}"
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @my-filter Test
          Lorem ipsum
        INPUT
          arg: Test
          Lorem ipsum
        OUTPUT
      end

      it "can have filters with multiple arguments" do
        LivingStyleGuide.command :my_second_filter do |arguments, options, block|
          "arg1: #{arguments[0]}\narg2: #{arguments[1]}\narg3: #{arguments[2]}"
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @my-second-filter 'Test\''; Test\\; with semicolon; "More test\""
          Lorem ipsum
        INPUT
          arg1: 'Test''
          arg2: Test; with semicolon
          arg3: More test"
          Lorem ipsum
        OUTPUT
      end

      it "can have options" do
        LivingStyleGuide.command :my_option_filter do |arguments, options, block|
          "a: #{options[:a]}\nb: #{options[:b]}\nc: #{options[:c]}"
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @my-option-filter b: '1\''; c: 1\\; 2; a: "Lorem\""
          Lorem ipsum
        INPUT
          a: Lorem"
          b: '1''
          c: 1; 2
          Lorem ipsum
        OUTPUT
      end

    end

    describe "filters with blocks in braces" do

      it "can have filters with a block" do
        LivingStyleGuide.command :x do |arguments, options, block|
          block.unindent.gsub(/\w/, "X")
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @x {
            Lorem ipsum
            dolor
          }
          Lorem ipsum
        INPUT
          XXXXX XXXXX
          XXXXX
          Lorem ipsum
        OUTPUT
      end

      it "can have filters with multiple arguments and a block" do
        LivingStyleGuide.command :y do |arguments, options, block|
          "arg1: #{arguments[0]}\narg2: #{arguments[1]}\n#{block.gsub(/\w/, "Y")}"
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @y 1; 2 {
            Lorem ipsum
            dolor
          }
          Lorem ipsum
        INPUT
          arg1: 1
          arg2: 2
            YYYYY YYYYY
            YYYYY
          Lorem ipsum
        OUTPUT
      end

      it "blocks should allow CSS (nested {})" do
        LivingStyleGuide.command :css_test do |arguments, options, block|
          block.unindent
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @css-test {
            .my-class {
              background: black;
              &:hover {
                background: red;
              }
            }
          }
          Lorem ipsum
          @css-test {
            .my-class {
              background: black;
              &:hover {
                background: red;
              }
            }
          }
          Lorem ipsum
        INPUT
          .my-class {
            background: black;
            &:hover {
              background: red;
            }
          }
          Lorem ipsum
          .my-class {
            background: black;
            &:hover {
              background: red;
            }
          }
          Lorem ipsum
        OUTPUT
      end

      it "can have filters within filters" do
        LivingStyleGuide.command :inner do |arguments, options, block|
          "<inner>"
        end
        LivingStyleGuide.command :outer do |arguments, options, block|
          inner = LivingStyleGuide::Document.new(livingstyleguide: document){ block }.render
          "<outer>#{inner}</outer>"
        end
        assert_document_match <<-INPUT, <<-OUTPUT, type: :plain
          @outer {
          @inner
          }
        INPUT
          <outer>.*<inner>.*</outer>
        OUTPUT
      end
    end

    describe "filters with indented blocks" do

      it "can have filters with an indented block" do
        LivingStyleGuide.command :x_indented do |arguments, options, block|
          block.gsub(/\w/, "X")
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @x-indented
            Lorem ipsum
            dolor
          Lorem ipsum
        INPUT
          XXXXX XXXXX
          XXXXX
          Lorem ipsum
        OUTPUT
      end

      it "can have filters with an indented block with tabs" do
        LivingStyleGuide.command :x_indented do |arguments, options, block|
          block.gsub(/\w/, "X")
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @x-indented
          \tLorem ipsum
          \tdolor
          Lorem ipsum
        INPUT
          XXXXX XXXXX
          XXXXX
          Lorem ipsum
        OUTPUT
      end

      it "can have filters with an indented block at the end of the file" do
        LivingStyleGuide.command :x_indented do |arguments, options, block|
          block.gsub(/\w/, "X")
        end
        assert_document_equal <<-INPUT.rstrip, <<-OUTPUT, type: :plain
          @x-indented
            Lorem ipsum
            dolor
        INPUT
          XXXXX XXXXX
          XXXXX
        OUTPUT
      end

      it "can have filters with multiple arguments and an indented block" do
        LivingStyleGuide.command :y_indented do |arguments, options, block|
          "arg1: #{arguments[0]}\narg2: #{arguments[1]}\n#{block.gsub(/\w/, "Y")}"
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @y-indented 1; 2
            Lorem ipsum
            dolor
          Lorem ipsum
        INPUT
          arg1: 1
          arg2: 2
          YYYYY YYYYY
          YYYYY
          Lorem ipsum
        OUTPUT
      end

    end

    describe "filters with blocks ending by newline" do

      it "can have filters with an indented block" do
        LivingStyleGuide.command :x_newline do |arguments, options, block|
          block.gsub(/\w/, "X")
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @x-newline:
          Lorem ipsum
          dolor

          Lorem ipsum
        INPUT
          XXXXX XXXXX
          XXXXX
          Lorem ipsum
        OUTPUT
      end

      it "can have filters with an indented block at the end of the file" do
        LivingStyleGuide.command :x_newline do |arguments, options, block|
          block.gsub(/\w/, "X")
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @x-newline:
          Lorem ipsum
          dolor
        INPUT
          XXXXX XXXXX
          XXXXX
        OUTPUT
      end

      it "can have filters with multiple arguments and an indented block" do
        LivingStyleGuide.command :y_newline do |arguments, options, block|
          "arg1: #{arguments[0]}\narg2: #{arguments[1]}\n#{block.gsub(/\w/, "Y")}"
        end
        assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
          @y-newline 1; 2:
          Lorem ipsum
          dolor

          Lorem ipsum
        INPUT
          arg1: 1
          arg2: 2
          YYYYY YYYYY
          YYYYY
          Lorem ipsum
        OUTPUT
      end
    end

    it "blocks should allow indented CSS (nested {})" do
      LivingStyleGuide.command :css_test_indented do |arguments, options, block|
        block
      end
      assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
        @css-test-indented
          .my-class
            background: black
            &:hover
              background: red
        Lorem ipsum
      INPUT
        .my-class
          background: black
          &:hover
            background: red
        Lorem ipsum
      OUTPUT
    end

    it "should ignore “@” in the middle of the text" do
      assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
        Lorem @ipsum
      INPUT
        Lorem @ipsum
      OUTPUT
    end

    it "should escape “\\@” in the beginning of the text" do
      assert_document_equal <<-INPUT, <<-OUTPUT, type: :plain
        \\@lorem ipsum
      INPUT
        @lorem ipsum
      OUTPUT
    end

    it "can have commands within commands" do
      LivingStyleGuide.command :inner do |arguments, options, block|
        "<inner>"
      end
      LivingStyleGuide.command :outer do |arguments, options, block|
        inner = LivingStyleGuide::Document.new(livingstyleguide: document){ block }.render
        "<outer>#{inner}</outer>"
      end
      assert_document_match <<-INPUT, <<-OUTPUT, type: :plain
        @outer
          @inner
      INPUT
        <outer>.*<inner>.*</outer>
      OUTPUT
    end
  end

  describe "templates" do

    it "should use template" do
      File.stub :read, "*<%= html %>*" do
        assert_document_equal "Test", "*Test*", type: :plain, template: "my-template"
      end
    end

    it "should use the example template" do
      assert_document_equal <<-INPUT, <<-OUTPUT
        ```
        <div>Test</div>
        ```
      INPUT
        <section class="lsg-example lsg-html-example" id="section-61ecba">
          <div class="lsg-html">
            <div>Test</div>
          </div>
          <pre class="lsg-code-block"><code class="lsg-code"><b>&lt;<em>div</em></b><b>&gt;</b>Test<b>&lt;/<em>div</em>&gt;</b></code></pre>
        </section>
      OUTPUT
    end

    it "should use the example template" do
      assert_document_equal <<-INPUT, <<-OUTPUT
        ``` example
        @haml
        %div Test
        ```
      INPUT
        <section class="lsg-example lsg-haml-example" id="section-b6e9ab">
          <div class="lsg-html">
            <div>Test</div>
          </div>
          <pre class="lsg-code-block"><code class="lsg-code"><em>%div</em> Test</code></pre>
        </section>
      OUTPUT
    end

  end

  describe "CSS" do

    it "should output CSS from SCSS source" do
      doc = LivingStyleGuide::Document.new { "" }
      doc.scss << <<-SCSS
        $color: #bd0d5e;
        #test {
          color: $color;
        }
      SCSS
      doc.css.must_match(/#test\s*\{\s*color: #bd0d5e;\s*\}/m)
    end

  end

  describe "IDs" do

    it "should generate IDs by headline" do
      doc = LivingStyleGuide::Document.new do
        <<-MARKDOWN.unindent(ignore_blank: true)
          # My Component

          ```
          <div></div>
          ```

          ```
          <div></div>
          ```

          ## Another Component

          ```
          <div></div>
          ```
        MARKDOWN
      end
      html = doc.render
      html.must_match(/id="my-component-1"/)
      html.must_match(/id="my-component-2"/)
      html.must_match(/id="another-component-1"/)
    end

    it "should generate IDs by headline and document name" do
      doc = LivingStyleGuide::Document.new "folder/_my-file.lsg" do
        <<-MARKDOWN.unindent(ignore_blank: true)
          ```
          <div></div>
          ```

          # My File

          ```
          <div></div>
          ```

          # My Component

          ```
          <div></div>
          ```

          ```
          <div></div>
          ```

          ## Another Component

          ```
          <div></div>
          ```
        MARKDOWN
      end
      html = doc.render
      html.must_match(/id="my-file-1"/)
      html.must_match(/id="my-file-2"/)
      html.must_match(/id="my-file-my-component-1"/)
      html.must_match(/id="my-file-my-component-2"/)
      html.must_match(/id="my-file-another-component-1"/)
    end

    it "should generate IDs by hash" do
      doc = LivingStyleGuide::Document.new { "# Test" }
      doc.id.must_match(/^section-[0-9a-f]{6}$/)
    end

    it "should generate IDs by file name" do
      doc = LivingStyleGuide::Document.new("test/fixtures/import/_headline-partial.lsg")
      doc.id.must_equal("test/fixtures/import/headline-partial")
    end

  end

  describe "Data" do

    it "should use data in Haml templates" do
      assert_document_equal <<-INPUT, <<-OUTPUT, data: { foo: "Bar" }, type: :haml
        %div= foo
      INPUT
        <div>Bar</div>
      OUTPUT
    end

    it "should allow ERB templates that don’t conflict with filters" do
      assert_document_equal <<-INPUT, <<-OUTPUT, data: { foo: "Bar" }, type: :erb
        <div><%= foo %></div>
      INPUT
        <div>Bar</div>
      OUTPUT
    end

  end

  describe "highlights in code" do

    it "should highlight text in a line" do
      doc = LivingStyleGuide::Document.new { "This is ***highlighted*** text." }
      doc.type = :plain
      doc.template = :plain
      doc.render
      assert_equal "This is highlighted text.", doc.html
      assert_equal %Q(This is <strong class="lsg-code-highlight">highlighted</strong> text.), doc.highlighted_source
    end

    it "should highlight text in a line" do
      doc = LivingStyleGuide::Document.new { "This is ***highlighted***" }
      doc.type = :plain
      doc.template = :plain
      doc.render
      assert_equal "This is highlighted", doc.html
      assert_equal %Q(This is <strong class="lsg-code-highlight">highlighted</strong>), doc.highlighted_source
    end

    it "should highlight text in source code" do
      doc = LivingStyleGuide::Document.new { "<b>This</b> is ***highlighted*** <b class=\"***class***\">text</b>." }
      doc.type = :html
      doc.template = :plain
      doc.render
      assert_equal "<b>This</b> is highlighted <b class=\"class\">text</b>.", doc.html
      assert_equal "<b>&lt;<em>b</em></b><b>&gt;</b>This<b>&lt;/<em>b</em>&gt;</b> is <strong class=\"lsg-code-highlight\">highlighted</strong> <b>&lt;<em>b</em></b> <b>class</b>=&quot;<strong class=\"lsg-code-highlight\">class</strong>&quot;<b>&gt;</b>text<b>&lt;/<em>b</em>&gt;</b>.", doc.highlighted_source
    end

    it "should highlight text spanning several lines" do
      doc = LivingStyleGuide::Document.new do
        <<-INPUT.unindent
          This is
          ***
          highlighted
          ***
          text.
        INPUT
      end
      doc.type = :plain
      doc.template = :plain
      doc.render
      assert_equal "This is\n\nhighlighted\n\ntext.\n", doc.html
      assert_equal "This is<br><strong class=\"lsg-code-highlight\"><br>highlighted<br></strong><br>text.", doc.highlighted_source
    end
  end
end
