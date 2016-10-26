require 'date'
require 'markdo/data_source'
require 'markdo/models/task'

module Markdo
  class TaskCollection
    def self.fetch
      Promise.new.tap do |promise|
        DataSource.http_get('data/__all__.md').then do |response|
          markdown = response.body
          lines = markdown.split("\n")
          task_collection = new(lines)
          promise.resolve(task_collection)
        end
      end
    end

    def initialize(lines, today = Date.today)
      @lines = lines
      @today = today
    end

    def all
      tasks
    end

    def complete
      tasks.select { |task| task.complete? }
    end

    def with_tag(tag)
      tasks.select { |task| task.attributes[tag.downcase] }
    end

    def with_attribute(tag)
      with_tag(tag)
    end

    def with_match(matcher)
      tasks.select { |task| task.line.match(matcher) }
    end

    def starred
      with_tag('star')
    end

    def due_on(given_date)
      with_date('due') { |date| date == given_date }
    end

    def due_between(begin_date, end_date)
      with_date('due') { |date| date >= begin_date && date <= end_date }
    end

    def overdue
      with_date('due') { |date| date < @today }
    end

    def due_today
      due_on(@today)
    end

    def due_tomorrow
      due_on(@today + 1)
    end

    def due_soon
      due_between(@today + 2, @today + 7)
    end

    def deferred_until_today
      with_date('defer') { |date| date <= @today }
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
