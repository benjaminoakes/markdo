require 'markdo/command'
require 'markdo/data_source'
require 'markdo/ics_exporter'
require 'markdo/models/task_collection'

module Markdo
  class IcsCommand < Command
    def run
      ics_exporter = IcsExporter.new(task_collection)
      ics = ics_exporter.to_ics

      @stdout.puts(ics)
    end

    private

    def task_collection
      lines = DataSource.new(@env).all_lines
      TaskCollection.new(lines)
    end
  end
end
