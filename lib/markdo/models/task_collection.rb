require 'date'
require 'markdo/models/task'

module Markdo
  class TaskCollection
    def initialize(lines, reference_date = Date.today)
      @lines = lines
      @reference_date = reference_date
    end

    def all
      tasks
    end

    def with_tag(tag)
      tasks.select { |task| task.attributes[tag.downcase] }
    end

    def with_attribute(tag)
      with_tag(tag)
    end

    def starred
      with_tag('star')
    end

    def overdue
      with_date('due') { |date| date < @reference_date }
    end

    def due_today
      with_date('due') { |date| date == @reference_date }
    end

    def due_tomorrow
      with_date('due') { |date| date == @reference_date + 1 }
    end

    def due_soon
      with_date('due') { |date| date > @reference_date + 1 && date < @reference_date + 8 }
    end

    def deferred_until_today
      with_date('defer') { |date| date <= @reference_date }
    end

    private

    def with_date(attribute, &block)
      with_attribute(attribute).
        select { |task| block.call(task.attributes[attribute].date_value) }.
        sort_by { |task| task.attributes[attribute].date_value }
    end

    def tasks
      @tasks ||= parse
    end

    def parse
      @lines.map { |line| Task.new(line) }
    end
  end
end
