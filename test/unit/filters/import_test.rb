require 'document_test_helper'

class ImportTest < DocumentTestCase

  LivingStyleGuide::Filters.add_filter :foo do |text|
    "# #{text.capitalize} #{text.capitalize}"
  end

  def test_import_lsg
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/_headline.lsg

      After
    INPUT
      <p.+?>Before</p>
      <h2.+?>Imported</h2>
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_lsg_without_extension
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/_headline

      After
    INPUT
      <p.+?>Before</p>
      <h2.+?>Imported</h2>
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_filter
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/_filter.lsg

      After
    INPUT
      <p.+?>Before</p>
      <h2.+?>Bar Bar</h2>
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_multiple
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/*

      After
    INPUT
      <p.+?>Before</p>
      <h2.+?>Bar Bar</h2>
      <h2.+?>Imported</h2>
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_haml
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/_haml.haml

      After
    INPUT
      <p.+?>Before</p>
      <div class='foo'>Bar</div>
      <p.+?>After</p>
    OUTPUT
  end

end
