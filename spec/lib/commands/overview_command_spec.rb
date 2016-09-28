require 'spec_helper'
require 'markdo/commands/overview_command'

module Markdo
  describe OverviewCommand do
    it 'outputs tasks overdue, starred, due today, and due tomorrow' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, *rest = build_date_commands_support

      OverviewCommand.new(out, *rest).run

      expect(out.string).to eq(<<-EOF)
- [ ] @due(2016-01-01) Overdue in inbox
- [ ] @due(2016-01-01) Overdue
- [ ] @star Starred in inbox
- [ ] @star Starred
- [ ] @due(2016-02-28) Due today in inbox
- [ ] @due(2016-02-28) Due today
- [ ] @due(2016-02-29) Due tomorrow in inbox
- [ ] @due(2016-02-29) Due tomorrow
      EOF
    end
  end
end
