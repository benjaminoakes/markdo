require 'markdo/commands/command'

module Markdo
  class OverviewCommand < Command
    def run
      tasks = task_collection.overdue +
        task_collection.starred +
        task_collection.due_today +
        task_collection.due_tomorrow

      tasks.each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
