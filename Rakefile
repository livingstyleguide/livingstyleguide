require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new :test do |t|
  t.libs << 'lib'
  t.libs << 'test'
  test_files = FileList['test/**/*_test.rb']
  t.test_files = test_files
  t.verbose = true
end

desc 'Deploys the website to livingstyleguide.org'
task :deploy do
  Bundler.with_clean_env do
    system 'cd website && bundle && bundle exec middleman build'
    branch = `git rev-parse --abbrev-ref HEAD`.strip
    path   = "#{"branches/#{branch}/" unless branch == 'master'}"
    if branch == 'master'
      path = 'html'
      domain = 'livingstyleguide.org'
    else
      domain = path = branch.gsub('/', '-') + '.preview.livingstyleguide.org'
    end
    system "rsync -avz website/build/ lsg@livingstyleguide.org:/var/www/virtual/lsg/#{path}"
    puts "Sucessfully deployed website to http://#{domain}"
  end
end

task :release do
  branch = `git rev-parse --abbrev-ref HEAD`.strip
  raise 'Please switch to `master` first.' unless branch == 'master'
  Rake::Task['deploy'].execute
end

task :default => [:test]

