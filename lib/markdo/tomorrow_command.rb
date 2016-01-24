require 'date'
require 'markdo/date_command'

module Markdo
  class TomorrowCommand < DateCommand
    def run
      super(Date.today + 1)
    end
  end
end
