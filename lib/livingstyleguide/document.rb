# encoding: utf-8

class LivingStyleGuide::Document
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def render
    @source
  end
end
