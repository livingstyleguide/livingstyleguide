require "bundler/gem_tasks"
require "rake/testtask"
require "scss_lint/rake_task"

def branch
  `git rev-parse --abbrev-ref HEAD`.strip
end

Rake::TestTask.new :test do |t|
  t.libs << "lib"
  t.libs << "test"
  test_files = FileList["test/**/*_test.rb"]
  t.test_files = test_files
  t.verbose = true
  t.warning = false
end

SCSSLint::RakeTask.new do |t|
  t.config = ".scss-style.yml"
  t.files = FileList["**/*.scss"]
end

desc "Deploys the website to livingstyleguide.org"
task :deploy do
  Bundler.with_clean_env do
    system "cd website && bundle && bundle exec middleman build"
    case branch
    when "master", "v2"
      path = "html"
    else
      path = "preview.livingstyleguide.org"
    end
    domain = "livingstyleguide.org"
    server_path = "lsg@lsg.vulpecula.uberspace.de:/var/www/virtual/lsg/#{path}"
    system "rsync -avz website/build/ #{server_path}"
    puts "Sucessfully deployed website to http://#{domain}"
  end
end

desc "Releases the Gem and updates the website"
task :release do
  raise "Please switch to `master` first." unless branch == "master"
  Rake::Task["deploy"].execute
end

task default: [:scss_lint, :test]
