require 'date'
require 'markdo/commands/command'

module Markdo
  class TomorrowCommand < Command
    def run
      task_collection.due_tomorrow.each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
