require "bundler/gem_tasks"

task default: %w(spec spec:opal:phantomjs)

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

require 'fileutils'
require 'uglifier'
require 'opal'
desc 'Compile to docs/js/markdo_client.js'
task :compile_opal do
  Opal.append_path 'lib'
  FileUtils.mkdir_p 'docs/js'
  File.binwrite 'docs/js/markdo_client.js', Opal::Builder.build('markdo_client').to_s
  File.binwrite 'docs/js/markdo_client.min.js', Uglifier.compile(File.read('docs/js/markdo_client.js', encoding: 'UTF-8'))
end
