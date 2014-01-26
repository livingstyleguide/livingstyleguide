require 'test_helper'
require 'active_support/core_ext/string/inflections'

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

  def test_filters
    @class.add_filter :test do
      filter_example do |html|
        "TEST"
      end
    end
    assert_render_equals <<-INPUT, <<-OUTPUT
      @test
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

  def test_default_filters
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

end

