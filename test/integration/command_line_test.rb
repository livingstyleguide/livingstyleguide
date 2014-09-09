require 'test_helper'
require 'open3'

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

  it "should read from STDIN and write to STDOUT" do
    stdin, stdout = Open3.popen2('./bin/livingstyleguide compile')
    stdin.puts 'source: test/fixtures/standalone/style.scss'
    stdin.close
    stdout.read.must_match %r(<button class="button">)
    File.exists?('test/fixtures/standalone/styleguide.html').must_equal false
  end

end

