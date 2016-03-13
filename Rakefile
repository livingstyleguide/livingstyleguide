require "bundler/gem_tasks"
require "rake/testtask"
require "scss_lint/rake_task"

Rake::TestTask.new :test do |t|
  t.libs << "lib"
  t.libs << "test"
  test_files = FileList["test/**/*_test.rb"]
  t.test_files = test_files
  t.verbose = true
end

SCSSLint::RakeTask.new do |t|
  t.config = ".scss-style.yml"
  t.files = FileList["**/*.scss"]
end

desc "Deploys the website to livingstyleguide.org"
task :deploy do
  Bundler.with_clean_env do
    system "cd website && bundle && bundle exec middleman build"
    path = "html"
    domain = "livingstyleguide.org"
    system "rsync -avz website/build/ lsg@lsg.vulpecula.uberspace.de:/var/www/virtual/lsg/#{path}"
    puts "Sucessfully deployed website to http://#{domain}"
  end
end

desc "Releases the Gem and updates the website"
task :release do
  branch = `git rev-parse --abbrev-ref HEAD`.strip
  raise "Please switch to `master` first." unless branch == "master"
  Rake::Task["deploy"].execute
end

task default: [:scss_lint, :test]
