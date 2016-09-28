require 'date'
require 'markdo/commands/query_command'
require 'markdo/commands/week_command'

module Markdo
  class ForecastCommand < Command
    attr_reader :date

    def initialize(out, err, env, date)
      @date = date
      super(out, err, env, date)
    end

    def run
      dates_over_the_next_week.each do |date|
        abbreviation = weekday_abbreviation(date)
        count = task_collection.due_on(date).length

        @stdout.puts("#{abbreviation}: #{count}")
      end

      due_next_week = task_collection.due_between(@date + 7, @date + 14)
      @stdout.puts("Next: #{due_next_week.length}")
    end

    private

    def abbreviations_by_wday(wday)
      abbrevs = {
        0 => 'Su',
        1 => 'Mo',
        2 => 'Tu',
        3 => 'We',
        4 => 'Th',
        5 => 'Fr',
        6 => 'Sa',
      }

      abbrevs[wday]
    end

    def weekday_abbreviation(date)
      abbreviations_by_wday(date.wday)
    end

    private

    def dates_over_the_next_week
      (2..7).to_a.map { |offset| @date + offset }
    end
  end
end
