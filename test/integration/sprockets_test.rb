require "test_helper"
require "tilt"

describe "Sprockets integration" do

  describe "sprockets should know when to invalidate cache" do
    template = Tilt.new("test/fixtures/standalone/styleguide.html.lsg")
    context = Minitest::Mock.new
    %w(style.scss modules/_buttons.lsg).each do |file|
      file = File.expand_path("test/fixtures/standalone/#{file}")
      context.expect :depend_on, nil, [file]
    end

    template.render context

    context.verify
  end

end
