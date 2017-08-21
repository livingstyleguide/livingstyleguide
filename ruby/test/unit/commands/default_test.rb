require "document_test_helper"

class DefaultTest < DocumentTestCase

  LivingStyleGuide.command :test_default do |arguments, options, block|
    options[:foo]
  end

  def test_not_set
    assert_render_match <<-INPUT, <<-OUTPUT
      @test-default
    INPUT
    OUTPUT
  end

  def test_set_global
    assert_render_match <<-INPUT, <<-OUTPUT
      @default foo: global
      @test-default
    INPUT
      global
    OUTPUT
  end

  def test_set_global_per_command
    assert_render_match <<-INPUT, <<-OUTPUT
      @default foo: global
      @default @test-default; foo: bar
      @test-default
    INPUT
      bar
    OUTPUT
  end

  def test_set_local
    assert_render_match <<-INPUT, <<-OUTPUT
      @default foo: global
      @default @test-default; foo: bar
      @test-default foo: BAR
    INPUT
      BAR
    OUTPUT
  end

end
