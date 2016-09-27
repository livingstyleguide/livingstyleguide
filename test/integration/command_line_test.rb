require "test_helper"
require "open3"

describe "LivingStyleGuide::CommandLineInterface" do

  # COMPILE

  it "should output the style guide from *.html.lsg source" do
    cli "compile styleguide.html.lsg" do |stdout|
      File.exist?("styleguide.html").must_equal true
      stdout.strip.must_equal <<-STDOUT.strip
        Successfully generated a living style guide at styleguide.html.
      STDOUT
    end
  end

  it "should output the style guide from *.lsg source" do
    cli "compile styleguide.lsg" do |stdout|
      File.exist?("styleguide.html").must_equal true
      stdout.strip.must_equal <<-STDOUT.strip
        Successfully generated a living style guide at styleguide.html.
      STDOUT
    end
  end

  it "should use different output file" do
    cli "compile styleguide.lsg hello-world.html" do |stdout|
      File.exist?("hello-world.html").must_equal true
      stdout.strip.must_equal <<-STDOUT.strip
        Successfully generated a living style guide at hello-world.html.
      STDOUT
    end
  end

  it "should read from STDIN and write to STDOUT" do
    cli "compile", <<-STDIN.unindent do |stdout|
      @import modules/buttons
    STDIN
      File.exist?("styleguide.html").must_equal false
      stdout.must_match %r(<button class="button">)
    end
  end

  # VERSION

  it "should show the current version" do
    cli "version" do |stdout|
      stdout.must_match %r(LivingStyleGuide #{LivingStyleGuide::VERSION})
    end
  end

  # support

  def cli(command, input = nil, &block)
    stdin, stdout = Open3.popen2("../../../bin/livingstyleguide #{command}")
    stdin.puts input
    stdin.close

    yield stdout.read
  end

  before do
    @current_path = Dir.pwd
    Dir.chdir "test/fixtures/standalone"
    @files = Dir.glob("*")
  end

  after do
    (Dir.glob("*") - @files).each do |file|
      File.unlink file
    end
    Dir.chdir @current_path
  end

end
