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

      stringio = StringIO.new
      next_week_command = WeekCommand.new(stringio, @stderr, @env, @date + 7)
      next_week_command.run
      next_week_count = stringio.string.split("\n").length
      @stdout.puts("Next: #{next_week_count}")
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

    def justify(less_than_100)
      less_than_100.to_s.rjust(2, '0')
    end
  end
end
