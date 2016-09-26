require "bundler/gem_tasks"
require 'rake/testtask'

task default: %w(test spec spec:opal)

Rake::TestTask.new('test') do |t|
  t.libs = %w(lib test)
  t.test_files = FileList.new("test/**/*_test.rb")
end

task :clean do
  require 'fileutils'
  FileUtils.rm_rf('pkg')
end

require 'rspec/core/rake_task'

desc "Run the specs."
RSpec::Core::RakeTask.new('spec')

require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new('spec:opal') do |server, task|
  server.append_path 'lib'
end
