require 'date'
require 'markdo/commands/query_command'

module Markdo
  # TODO: More testing of this logic.  As of 2016-01-23, I was building this
  # project as a proof of concept.
  class OverdueCommand < Command
    def initialize(out, err, env, reference_date)
      @date = reference_date
      super(out, err, env, reference_date)
    end

    def run
      query_command = QueryCommand.new(@stdout, @stderr, @env)

      all_queries.each do |query|
        query_command.run(query)
      end
    end

    private

    def all_queries
      [previous_years, previous_months_this_year, previous_days_this_month].flatten
    end

    def previous_days_this_month
      (1...@date.day).to_a.map { |day|
        "#{@date.year}-#{justify(@date.month)}-#{justify(day)}"
      }
    end

    def previous_months_this_year
      (1...@date.month).to_a.map { |month|
        "#{@date.year}-#{justify(month)}"
      }
    end

    def previous_years
      (2000...@date.year).to_a.map { |year| "#{year}-" }
    end

    def justify(less_than_100)
      less_than_100.to_s.rjust(2, '0')
    end
  end
end
