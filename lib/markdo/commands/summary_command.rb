require 'markdo/commands/command'

module Markdo
  class SummaryCommand < Command
    def run
      print_count('Overdue', task_collection.overdue)
      print_count('Starred', task_collection.with_tag('star'))
      print_count('Today', task_collection.due_today)
      print_count('Tomorrow', task_collection.due_tomorrow)
      print_count('Soon', task_collection.due_soon)

      print_count('Inbox', inbox_task_collection.all)
    end

    private

    def print_count(name, tasks)
      count = tasks.length

      unless count.zero?
        @stdout.puts "#{name}: #{count}"
      end
    end
  end
end
