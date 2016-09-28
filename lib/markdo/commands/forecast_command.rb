require 'date'
require 'markdo/commands/query_command'
require 'markdo/commands/week_command'

module Markdo
  # TODO: More testing of this logic.  As of 2016-01-23, I was building this
  # project as a proof of concept.
  class ForecastCommand < Command
    attr_reader :date

    def initialize(out, err, env, date)
      @date = date
      super(out, err, env, date)
    end

    def run
      # This is pretty ugly, but works.  Just testing out how useful the concept is.
      dates = dates_over_the_next_week
      dates.shift
      dates.shift

      dates.each do |query|
        stringio = StringIO.new
        query_command = QueryCommand.new(stringio, @stderr, @env)
        query_command.run(query)

        abbreviation = weekday_abbreviation(query)
        count = stringio.string.split("\n").length

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

    def weekday_abbreviation(iso8601_date)
      wday = Date.strptime(iso8601_date, '%Y-%m-%d').wday
      abbreviations_by_wday(wday)
    end

    private

    def dates_over_the_next_week
      (0..7).to_a.map { |offset|
        adjusted_date = @date + offset
        "#{adjusted_date.year}-#{justify(adjusted_date.month)}-#{justify(adjusted_date.day)}"
      }
    end

    def justify(less_than_100)
      less_than_100.to_s.rjust(2, '0')
    end
  end
end
