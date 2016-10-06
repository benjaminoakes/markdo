require 'spec_helper'
require 'markdo/commands/summary_command'

module Markdo
  describe SummaryCommand do
    it 'outputs summary counts' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_for_date_commands

      SummaryCommand.new(command_support).run

      expect(command_support.stdout.string).to eq(<<-XML)
Overdue: 2
Starred: 2
Today: 2
Tomorrow: 2
Soon: 2
Inbox: 6
      XML
    end
  end
end
