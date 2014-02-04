require 'test_helper'

class ExampleTest < ExampleTestCase

  def test_default
    assert_render_equals <<-INPUT, <<-OUTPUT
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> <button>Hello World</button> </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt</b>
        </code>
      </pre>
    OUTPUT
  end

  def test_filters_with_underscore_and_dash_case
    @class.add_filter :test_filter do
      filter_example do |html|
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
            <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt</b>
          </code>
        </pre>
      OUTPUT
    end
  end

  def test_filters
    @class.add_filter do
      filter_example do |html|
        "TEST"
      end
    end
    assert_render_equals <<-INPUT, <<-OUTPUT
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> TEST </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt</b>
        </code>
      </pre>
    OUTPUT
  end

  def test_filters_with_argument
    @class.add_filter :test_filter do |argument|
      filter_example do |html|
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
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt</b>
        </code>
      </pre>
    OUTPUT
  end

  def test_default_filters
    @class.add_filter :test_filter do
      filter_example do |html|
        "TEST"
      end
    end
    assert_render_equals <<-INPUT, <<-OUTPUT, { default_filters: ['@test-filter'] }
      <button>Hello World</button>
    INPUT
      <div class="livingstyleguide--example"> TEST </div>
      <pre class="livingstyleguide--code-block">
        <code class="livingstyleguide--code">
          <b>&lt;<em>button</em></b><b>&gt;</b>Hello World<b>&lt;/<em>button</em>&gt</b>
        </code>
      </pre>
    OUTPUT
  end

end

