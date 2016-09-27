require "bundler/gem_tasks"

task default: %w(spec spec:opal:phantomjs spec:opal:nodejs)

task :clean do
  require 'fileutils'
  FileUtils.rm_rf('pkg')
end

require 'rspec/core/rake_task'

desc "Run the specs."
RSpec::Core::RakeTask.new('spec')

require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new('spec:opal:phantomjs') do |server, task|
  server.append_path 'lib'
end

Opal::RSpec::RakeTask.new('spec:opal:nodejs') do |server, task|
  task.runner = :node
  server.append_path 'lib'
end
