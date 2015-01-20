# encoding: utf-8

require 'tilt'

class LivingStyleGuide::Document
  attr_accessor :source, :type

  def initialize(source, type = :plain)
    @type = type
    @source = source
  end

  def render
    if @type == :plain
      @source
    else
      Tilt.new("*.#{@type}"){ @source }.render
    end
  end
end
