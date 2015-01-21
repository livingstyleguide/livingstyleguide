# encoding: utf-8

require 'tilt'
require 'erb'

class LivingStyleGuide::Document
  attr_accessor :source, :type

  def initialize(source, type = :plain)
    @type = type
    @source = source
  end

  def render
    run_filters
    if @type == :plain
      @source
    else
      Tilt.new("*.#{@type}"){ @source }.render
    end
  end

  def markdown
    @type = :markdown
    nil
  end

  private
  def run_filters
    erb = source.gsub(/@([\w\d_-]+)/, '<%= \\1 %>')
    @source = ERB.new(erb).result(binding)
  end
end
