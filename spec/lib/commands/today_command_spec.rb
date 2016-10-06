require 'spec_helper'
require 'markdo/commands/today_command'

module Markdo
  describe TodayCommand do
    it 'outputs tasks due today' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_for_date_commands

      TodayCommand.new(command_support).run

      expect(command_support.stdout.string).to eq(<<-EOF)
- [ ] @due(2016-02-28) Due today in inbox
- [ ] @due(2016-02-28) Due today
      EOF
    end
  end
end
