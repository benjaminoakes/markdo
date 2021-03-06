require 'date'
require 'markdo/commands/command'

module Markdo
  class TodayCommand < Command
    def run
      task_collection.due_today.each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
