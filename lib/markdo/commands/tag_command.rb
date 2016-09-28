require 'markdo/commands/command'

module Markdo
  class TagCommand < Command
    def run(string)
      task_collection.with_tag(string).each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
