require 'markdo/commands/command'

module Markdo
  class QueryCommand < Command
    def run(string)
      regexp = Regexp.new(string, Regexp::IGNORECASE)
      tasks = task_collection.with_match(regexp).reject(&:complete?)

      tasks.each do |task|
        @stdout.puts(task.line)
      end
    end
  end
end
