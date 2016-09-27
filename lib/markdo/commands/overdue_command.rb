require 'date'

module Markdo
  class OverdueCommand < Command
    def run
      task_collection.overdue.each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
