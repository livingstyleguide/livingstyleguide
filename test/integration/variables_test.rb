require 'test_helper'
require 'fileutils'
require 'compass'
require 'compass/logger'
require 'sass/plugin'

class VariablesImporterTest < Test::Unit::TestCase

  def setup
    Compass.configure_sass_plugin!
  end

  def render(scss)
    scss    = %Q(@import "compass"; #{scss})
    options = Compass.sass_engine_options
    options[:line_comments]      = false
    options[:style]              = :expanded
    options[:syntax]             = :scss
    options[:compass]          ||= {}
    options[:compass][:logger] ||= Compass::NullLogger.new
    css = Sass::Engine.new(scss, options).render
    format_css(css)
  end

  def format_css(css)
    css.gsub! %Q(@charset "UTF-8";), ''
    css.gsub! %r(\n), "\n      "
    css.gsub! %r( +$), ''
    css.gsub! %r(\n\n+), "\n"
    css.strip!
    %Q(      #{css}\n)
  end

  def test_output_of_variables
    css = render <<-SCSS
      %styleguide--code {
        test: code;
      }
      %styleguide--color {
        test: color;
      }
      @import "variables/colors";
      @import "variables:variables/colors";
    SCSS

    assert_equal <<-CSS, css
      .\\$my-wonderful_red:after, .\\$blue:after {
        test: code;
      }
      .\\$my-wonderful_red:before {
        test: color;
      }
      .\\$my-wonderful_red:before {
        background: red;
      }
      .\\$my-wonderful_red:after {
        content: "red";
      }
      .\\$blue:after {
        content: "blue";
      }
    CSS
  end
end
