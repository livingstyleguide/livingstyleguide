require 'test_helper'

describe LivingStyleGuide::Document do

  def assert_document_equals(input, output, options = {})
    input.gsub!(/^        /, '')
    @doc = LivingStyleGuide::Document.new { input }
    @doc.type = options[:type] || :markdown
    @doc.template = options[:template] || 'plain'
    actual = @doc.render(nil, options[:data]).gsub(/\n\n+/, "\n").strip
    expected = output.gsub(/^        /, '').gsub(/\n\n+/, "\n").strip
    actual.must_equal expected
  end

  describe "base features" do

    it "outputs the source" do
      doc = LivingStyleGuide::Document.new { "Test" }
      doc.source.must_equal "Test"
    end

    it "outputs the input as default" do
      assert_document_equals "Test", "Test", type: :plain
    end

    it "outputs the input as HTML for Markdown" do
      assert_document_equals <<-INPUT, <<-OUTPUT
        *Test*
      INPUT
        <p class="livingstyleguide--paragraph"><em>Test</em></p>
      OUTPUT
    end

  end

  describe "change type by filter" do

    it "allows to set the type to Markdown" do
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        @markdown
        *Test*
      INPUT
        <p class="livingstyleguide--paragraph"><em>Test</em></p>
      OUTPUT
    end

    it "allows to set the type to Haml" do
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        @haml
        %test Test
      INPUT
        <test>Test</test>
      OUTPUT
    end

    it "allows to set the type to Coffee-Script" do
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        @coffee-script
        alert "Test"
      INPUT
        (function() {
          alert("Test");
        }).call(this);
      OUTPUT
    end

    it "allows to set the type to Coffee-Script with short version" do
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        @coffee
        alert "Test"
      INPUT
        (function() {
          alert("Test");
        }).call(this);
      OUTPUT
    end

  end

  describe "filter syntax" do

    it "can have filters with an argument" do
      LivingStyleGuide::Filters.add_filter :my_filter do |arg|
        "arg: #{arg}"
      end
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        @my-filter Test
        Lorem ipsum
      INPUT
        arg: Test
        Lorem ipsum
      OUTPUT
    end

    it "can have filters with multiple arguments" do
      LivingStyleGuide::Filters.add_filter :my_second_filter do |arg1, arg2|
        "arg1: #{arg1}\narg2: #{arg2}"
      end
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        @my-second-filter Test, More test
        Lorem ipsum
      INPUT
        arg1: Test
        arg2: More test
        Lorem ipsum
      OUTPUT
    end

    it "can have filters with a block" do
      LivingStyleGuide::Filters.add_filter :x do |block|
        block.gsub(/\w/, 'X')
      end
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
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
      LivingStyleGuide::Filters.add_filter :y do |arg1, arg2, block|
        "arg1: #{arg1}\narg2: #{arg2}\n#{block.gsub(/\w/, 'Y')}"
      end
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        @y 1, 2 {
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
      LivingStyleGuide::Filters.add_filter :css_test do |block|
        block
      end
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
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

    it "can have filters with an indented block" do
      LivingStyleGuide::Filters.add_filter :x_indented do |block|
        block.gsub(/\w/, 'X')
      end
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
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

    it "can have filters with multiple arguments and an indented block" do
      LivingStyleGuide::Filters.add_filter :y_indented do |arg1, arg2, block|
        "arg1: #{arg1}\narg2: #{arg2}\n#{block.gsub(/\w/, 'Y')}"
      end
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        @y-indented 1, 2
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

    it "blocks should allow indented CSS (nested {})" do
      LivingStyleGuide::Filters.add_filter :css_test_indented do |block|
        block
      end
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
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
      assert_document_equals <<-INPUT, <<-OUTPUT, type: :plain
        Lorem @ipsum
      INPUT
        Lorem @ipsum
      OUTPUT
    end

  end

  describe "templates" do

    it "should use template" do
      File.stub :read, "*<%= html %>*" do
        assert_document_equals "Test", "*Test*", type: :plain, template: 'my-template'
      end
    end

    it "should use the example template" do
      assert_document_equals <<-INPUT, <<-OUTPUT
        ```
        <div>Test</div>
        ```
      INPUT
        <section class="livingstyleguide--example livingstyleguide--html-example" id="section-61ecba">
          <div class="livingstyleguide--html">
            <div>Test</div>
          </div>
          <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code"><b>&lt;<em>div</em></b><b>&gt;</b>Test<b>&lt;/<em>div</em>&gt</b>
        </code></pre>
        </section>
      OUTPUT
    end

    it "should use the example template" do
      assert_document_equals <<-INPUT, <<-OUTPUT
        ``` example
        @haml
        %div Test
        ```
      INPUT
        <section class="livingstyleguide--example livingstyleguide--haml-example" id="section-b6e9ab">
          <div class="livingstyleguide--html">
            <div>Test</div>
          </div>
          <pre class="livingstyleguide--code-block"><code class="livingstyleguide--code"><em>%div</em> Test
        </code></pre>
        </section>
      OUTPUT
    end

  end

  describe "CSS" do

    it "should output CSS from SCSS source" do
      doc = LivingStyleGuide::Document.new { '' }
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

    it "should generate IDs by hash" do
      doc = LivingStyleGuide::Document.new { '# Test' }
      doc.id.must_match(/^section-[0-9a-f]{6}$/)
    end

    it "should generate IDs by file name" do
      doc = LivingStyleGuide::Document.new('test/fixtures/import/_headline-partial.lsg')
      doc.id.must_equal('test/fixtures/import/headline-partial')
    end

  end

  describe "Data" do

    it "should use data in Haml templates" do
      assert_document_equals <<-INPUT, <<-OUTPUT, data: { foo: "Bar" }, type: :haml
        %div= foo
      INPUT
        <div>Bar</div>
      OUTPUT
    end

    it "should allow ERB templates that don’t conflict with filters" do
      assert_document_equals <<-INPUT, <<-OUTPUT, data: { foo: "Bar" }, type: :erb
        <div><%= foo %></div>
      INPUT
        <div>Bar</div>
      OUTPUT
    end

  end

end
