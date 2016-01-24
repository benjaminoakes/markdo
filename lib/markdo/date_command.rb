require 'markdo/query_command'

module Markdo
  class DateCommand < QueryCommand
    def run(date)
      super(date.iso8601)
    end
  end
end
