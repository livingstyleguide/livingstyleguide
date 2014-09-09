require 'test_helper'
require 'open3'

describe "LivingStyleGuide::CommandLineInterface" do

  it "should output the style guide from *.html.lsg source" do
    cli 'compile styleguide.html.lsg' do
      File.exists?('styleguide.html').must_equal true
    end
  end

  it "should output the style guide from *.lsg source" do
    cli 'compile styleguide.lsg' do
      File.exists?('styleguide.html').must_equal true
    end
  end

  it "should use different output file" do
    cli 'compile styleguide.lsg hello-world.html' do
      File.exists?('hello-world.html').must_equal true
    end
  end

  it "should read from STDIN and write to STDOUT" do
    cli 'compile', <<-STDIN do |stdout|
      source: style.scss
    STDIN
      File.exists?('styleguide.html').must_equal false
      stdout.must_match %r(<button class="button">)
    end
  end

  def cli(command, input = nil, &block)
    current_path = Dir.pwd
    Dir.chdir 'test/fixtures/standalone'
    files = Dir.glob('*')
    stdin, stdout = Open3.popen2("../../../bin/livingstyleguide #{command}")
    stdin.puts input
    stdin.close

    yield stdout.read

    (Dir.glob('*') - files).each do |file|
      File.unlink file
    end
    Dir.chdir current_path
  end

end

