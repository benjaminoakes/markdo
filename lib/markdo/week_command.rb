require 'date'
require 'markdo/query_command'

module Markdo
  # TODO: More testing of this logic.  As of 2016-01-23, I was building this
  # project as a proof of concept.
  class WeekCommand < Command
    def initialize(*)
      @date = Date.today
      super
    end

    def run
      query_command = QueryCommand.new(@stdout, @stderr, @env)

      dates_over_the_next_week.each do |query|
        query_command.run(query)
      end
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
