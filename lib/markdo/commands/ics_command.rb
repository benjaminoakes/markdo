require 'markdo/command'
require 'markdo/data_source'
require 'markdo/ics_exporter'
require 'markdo/models/task_collection'

module Markdo
  class IcsCommand < Command
    def run
      lines = DataSource.new(@env).all_lines
      task_collection = TaskCollection.new(lines)
      ics_exporter = IcsExporter.new(task_collection)
      ics = ics_exporter.to_ics

      @stdout.puts(ics)
    end
  end
end
