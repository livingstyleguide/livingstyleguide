require 'document_test_helper'

class SearchBoxText < DocumentTestCase

  def test_default_search_box
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @search-box
    INPUT
      .*<section class="lsg--before">.*<input type="search" class="lsg--search-box" placeholder="Search …" autofocus>.*</section>.*
    OUTPUT
  end

  def test_search_box_placeholder
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @search-box placeholder: Buscar
    INPUT
      .*<section class="lsg--before">.*<input type="search" class="lsg--search-box" placeholder="Buscar" autofocus>.*</section>.*
    OUTPUT
  end

  def test_custom_default_search_box
    backup = LivingStyleGuide.default_options[:search_box]
    LivingStyleGuide.default_options[:search_box] = { placeholder: "Buscar ..." }
    assert_render_match <<-INPUT, <<-OUTPUT, template: :layout
      @search-box
    INPUT
      .*<section class="lsg--before">.*<input type="search" class="lsg--search-box" placeholder="Buscar ..." autofocus>.*</section>.*
    OUTPUT
    LivingStyleGuide.default_options[:search_box] = backup
  end

end
