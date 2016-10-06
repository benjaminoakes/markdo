require 'spec_helper'
require 'markdo/commands/tomorrow_command'

module Markdo
  describe TomorrowCommand do
    it 'outputs tasks due tomorrow' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_for_date_commands

      TomorrowCommand.new(command_support).run

      expect(command_support.stdout.string).to eq(<<-EOF)
- [ ] @due(2016-02-29) Due tomorrow in inbox
- [ ] @due(2016-02-29) Due tomorrow
      EOF
    end
  end
end
