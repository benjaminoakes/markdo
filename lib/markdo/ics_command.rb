require 'markdo/command'
require 'markdo/ics_exporter'
require 'markdo/task_collection'

module Markdo
  class IcsCommand < Command
    def run
      lines = Dir.
        glob(markdown_glob).
        map { |path| File.readlines(path, encoding: 'UTF-8') }.
        flatten

      task_collection = TaskCollection.new(lines)
      ics_exporter = IcsExporter.new(task_collection)
      ics = ics_exporter.to_ics

      @stdout.puts(ics)
    end

    protected

    def markdown_glob
      "#{@env['MARKDO_ROOT']}/*.md"
    end
  end
end
