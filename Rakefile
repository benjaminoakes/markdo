require "bundler/gem_tasks"
require 'rake/testtask'

task default: 'test'

Rake::TestTask.new('test') do |t|
  t.libs = %w(lib test)
  t.test_files = FileList.new("test/**/*_test.rb")
end
