require 'markdo/commands/command'

module Markdo
  class StarCommand < Command
    def run
      task_collection.starred.each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
