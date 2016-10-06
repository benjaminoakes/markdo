require 'spec_helper'
require 'markdo/commands/overdue_command'

module Markdo
  describe OverdueCommand do
    it 'outputs overdue tasks' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_for_date_commands

      OverdueCommand.new(command_support).run

      expect(command_support.stdout.string).to eq(<<-EOF)
- [ ] @due(2016-01-01) Overdue in inbox
- [ ] @due(2016-01-01) Overdue
      EOF
    end
  end
end
