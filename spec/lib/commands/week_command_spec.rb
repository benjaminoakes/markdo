require 'spec_helper'
require 'markdo/commands/week_command'

module Markdo
  describe WeekCommand do
    it 'outputs tasks due over the next week, including today and tomorrow' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_for_date_commands

      WeekCommand.new(command_support).run

      expect(command_support.stdout.string).to eq(<<-EOF)
- [ ] @due(2016-02-28) Due today in inbox
- [ ] @due(2016-02-28) Due today
- [ ] @due(2016-02-29) Due tomorrow in inbox
- [ ] @due(2016-02-29) Due tomorrow
- [ ] @due(2016-03-06) Due soon in inbox
- [ ] @due(2016-03-06) Due soon
      EOF
    end
  end
end
