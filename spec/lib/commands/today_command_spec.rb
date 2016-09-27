require 'spec_helper'
require 'markdo/commands/today_command'

module Markdo
  describe TodayCommand do
    it 'outputs summary counts' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, err = build_command_support
      env = {
        'MARKDO_ROOT' => 'spec/fixtures/date_commands',
        'MARKDO_INBOX' => 'inbox.md'
      }

      TodayCommand.new(out, err, env, Date.new(2016, 2, 28)).run

      expect(out.string).to eq(<<-EOF)
- [ ] @due(2016-02-28) Due today
- [ ] @due(2016-02-28) Due today in inbox
      EOF
    end
  end
end
