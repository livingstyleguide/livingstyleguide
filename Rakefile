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
    system 'rsync -avz website/build/ lsg@livingstyleguide.org:/home/lsg/html/'
  end
end

task :release do
  Rake::Task['deploy'].execute
end

task :default => [:test]

