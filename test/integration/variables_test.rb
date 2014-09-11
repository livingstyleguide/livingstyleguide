require 'test_helper'
require 'fileutils'
require 'compass'
require 'compass/logger'
require 'sass/plugin'

class VariablesImporterTest < Minitest::Test

  def setup
    Compass.configure_sass_plugin!
  end

  def test_variables_outside_of_root
    html = render('test/fixtures/standalone/variables/gemfile/styleguide/styleguide.html.lsg')
    assert_match %r(\.\\\$green), html
    assert_match %r(\.\\\$red), html
  end

  private
  def render(file)
    Tilt.new(file).render.gsub(/\s+/, ' ')
  end

end

