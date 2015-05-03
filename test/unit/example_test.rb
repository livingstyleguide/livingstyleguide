require 'example_test_helper'

class ExampleTest < ExampleTestCase

  def test_default
    assert_render_equals <<-INPUT, <<-OUTPUT
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> <button>Hello World</button> </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt;</b>
        </code>
      </pre>
    OUTPUT
  end

  def test_filters_with_underscore_and_dash_case
    @class.add_filter :test_filter do
      filter_before do |html|
        "TEST"
      end
    end
    %w(test_filter test-filter).each do |filter|
      assert_render_equals <<-INPUT, <<-OUTPUT
        @#{filter}
        <button>Hello World</button>
      INPUT
        <div class="livingstyleguide--example"> TEST </div>
        <pre class="livingstyleguide--code-block">
          <code class="livingstyleguide--code">
            <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt;</b>
          </code>
        </pre>
      OUTPUT
    end
  end

  def test_filters
    @class.add_filter do
      filter_before do |html|
        "TEST"
      end
    end
    assert_render_equals <<-INPUT, <<-OUTPUT
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> TEST </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt;</b>
        </code>
      </pre>
    OUTPUT
  end

  def test_filters_with_argument
    @class.add_filter :test_filter do |argument|
      filter_before do |html|
        argument
      end
    end
    assert_render_equals <<-INPUT, <<-OUTPUT
      @test_filter Another Test
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> Another Test </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt;</b>
        </code>
      </pre>
    OUTPUT
  end

  def test_default_filters
    @class.add_filter :test_filter do
      filter_before do |html|
        "TEST"
      end
    end
    assert_render_equals <<-INPUT, <<-OUTPUT, { default_filters: ['@test-filter'] }
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> TEST </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt;</b>
        </code>
      </pre>
    OUTPUT
  end

  def test_outer_html
    @class.html do |c|
      "<span>#{c}</span>"
    end
    assert_render_equals <<-INPUT, <<-OUTPUT
      <button>Hello World</button>
    INPUT
      <span> <button>Hello World</button> </span>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt;</b>
        </code>
      </pre>
    OUTPUT
  end

  def test_hide_code_block
    @class.add_filter :suppress_code_block do
      suppress_code_block
    end
    assert_render_equals <<-INPUT, <<-OUTPUT
      @suppress-code-block
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> <button>Hello World</button> </div>
    OUTPUT
  end

  def test_pre_processor
    @class.add_filter :pre_processor_one do
      pre_processor { |source| 'fail' }
    end
    @class.add_filter :pre_processor_two do
      pre_processor { |source| source.gsub(/World/, 'Moon') }
    end
    assert_render_equals <<-INPUT, <<-OUTPUT
      @pre-processor-one
      @pre-processor-two
      Hello World
    INPUT
      <div class="livingstyleguide--example"> Hello Moon </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">Hello World</code>
      </pre>
    OUTPUT
  end

  def test_undefined_filter
    Proc.new do
      assert_render_equals <<-INPUT, ''
        @some-undefined-filter
        <button>Hello World</button>
      INPUT
    end.must_raise NameError
  end

end

