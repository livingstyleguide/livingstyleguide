require 'test_helper'

describe "LivingStyleGuide::CommandLineInterface" do

  it "should output the style guide from *.html.lsg source" do
    `./bin/livingstyleguide compile test/fixtures/standalone/styleguide.html.lsg`
    File.exists?('test/fixtures/standalone/styleguide.html').must_equal true
    File.delete 'test/fixtures/standalone/styleguide.html'
  end

  it "should output the style guide from *.lsg source" do
    `./bin/livingstyleguide compile test/fixtures/standalone/styleguide.lsg`
    File.exists?('test/fixtures/standalone/styleguide.html').must_equal true
    File.delete 'test/fixtures/standalone/styleguide.html'
  end

  it "should use different output file" do
    `./bin/livingstyleguide compile test/fixtures/standalone/styleguide.lsg test/fixtures/standalone/hello-world.html`
    File.exists?('test/fixtures/standalone/hello-world.html').must_equal true
    File.delete 'test/fixtures/standalone/hello-world.html'
  end

end

