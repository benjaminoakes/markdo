require 'date'
require 'markdo/commands/date_command'

module Markdo
  class TomorrowCommand < DateCommand
    def run
      super(@reference_date + 1)
    end
  end
end
