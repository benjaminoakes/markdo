require 'markdo/command'

module Markdo
  class InboxCommand < Command
    def run
      inbox_task_collection.all.each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
