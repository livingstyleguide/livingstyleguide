require 'test_helper'

describe "LivingStyleGuide::CommandLineInterface" do

  it "should output the style guide" do
    `./bin/livingstyleguide compile test/fixtures/standalone/style.html.lsg`
    File.exists?('test/fixtures/standalone/style.html').must_equal true
    File.delete 'test/fixtures/standalone/style.html'
  end

end

