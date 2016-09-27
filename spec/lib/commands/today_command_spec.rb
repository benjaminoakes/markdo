require 'spec_helper'
require 'markdo/commands/today_command'

module Markdo
  describe TodayCommand do
    it 'outputs tasks due today' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, *rest = build_date_commands_support

      TodayCommand.new(out, *rest).run

      expect(out.string).to eq(<<-EOF)
- [ ] @due(2016-02-28) Due today
- [ ] @due(2016-02-28) Due today in inbox
      EOF
    end
  end
end
