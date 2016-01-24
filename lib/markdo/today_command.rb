require 'date'
require 'markdo/date_command'

module Markdo
  class TodayCommand < DateCommand
    def run
      super(Date.today)
    end
  end
end
