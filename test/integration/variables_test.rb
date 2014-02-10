require 'test_helper'
require 'fileutils'
require 'compass'
require 'compass/logger'
require 'sass/plugin'

class VariablesImporterTest < Minitest::Test

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
end
