require 'test_helper'
require 'tilt'

describe "Sprockets integration" do

  describe "sprockets should know when to invalidate cache" do
    template = Tilt.new('test/fixtures/standalone/styleguide.html.lsg')
    context = Minitest::Mock.new
    %w(style.scss modules/_buttons.scss modules/_buttons.md styleguide.html.lsg).each do |file|
      context.expect :depend_on, nil, ["test/fixtures/standalone/#{file}"]
    end

    template.render context

    context.verify
  end

end

