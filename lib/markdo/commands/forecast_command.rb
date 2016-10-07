require 'date'
require 'markdo/commands/command'

module Markdo
  class ForecastCommand < Command
    def run
      dates_over_the_next_week.each do |date|
        abbreviation = abbreviations_by_wday(date.wday)
        count = task_collection.due_on(date).length

        @stdout.puts("#{abbreviation}: #{count}")
      end

      due_next_week = task_collection.due_between(@today + 7,
                                                  @today + 14)
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

    private

    def dates_over_the_next_week
      (2..7).to_a.map { |offset| @today + offset }
    end
  end
end
