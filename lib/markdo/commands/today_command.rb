require 'date'
require 'markdo/commands/date_command'

module Markdo
  class TodayCommand < DateCommand
    def run
      super(@reference_date)
    end
  end
end
