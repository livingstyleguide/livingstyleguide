require 'test_helper'
require 'open3'

describe "LivingStyleGuide::CommandLineInterface" do

  it "should output the style guide from *.html.lsg source" do
    cli('compile test/fixtures/standalone/styleguide.html.lsg') do
      File.exists?('test/fixtures/standalone/styleguide.html').must_equal true
    end
  end

  it "should output the style guide from *.lsg source" do
    cli('compile test/fixtures/standalone/styleguide.lsg') do
      File.exists?('test/fixtures/standalone/styleguide.html').must_equal true
    end
  end

  it "should use different output file" do
    cli('compile test/fixtures/standalone/styleguide.lsg test/fixtures/standalone/hello-world.html') do
      File.exists?('test/fixtures/standalone/hello-world.html').must_equal true
    end
  end

  it "should read from STDIN and write to STDOUT" do
    cli('compile', 'source: test/fixtures/standalone/style.scss') do
      File.exists?('test/fixtures/standalone/styleguide.html').must_equal false
    end.must_match %r(<button class="button">)
  end

  def cli(command, input = nil, &block)
    files = Dir.glob('test/fixtures/standalone/*')
    stdin, stdout = Open3.popen2("./bin/livingstyleguide #{command}")
    stdin.puts input
    stdin.close
    result = stdout.read

    yield

    (Dir.glob('test/fixtures/standalone/*') - files).each do |file|
      File.unlink file
    end
    result
  end

end

