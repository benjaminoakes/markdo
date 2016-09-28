require 'spec_helper'
require 'markdo/commands/week_command'

module Markdo
  describe WeekCommand do
    it 'outputs tasks due over the next week, including today and tomorrow' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, *rest = build_date_commands_support

      WeekCommand.new(out, *rest).run

      expect(out.string).to eq(<<-EOF)
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
