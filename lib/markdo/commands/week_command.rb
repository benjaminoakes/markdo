require 'date'
require 'markdo/commands/command'

module Markdo
  class WeekCommand < Command
    def run
      tasks = task_collection.due_today +
        task_collection.due_tomorrow +
        task_collection.due_soon

      tasks.each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
