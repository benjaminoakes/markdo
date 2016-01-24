require 'date'
require 'markdo/query_command'

module Markdo
  class TodayCommand < QueryCommand
    def run(today = Date.today)
      super(today.iso8601)
    end
  end
end
