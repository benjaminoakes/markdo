require 'spec_helper'
require 'markdo/commands/summary_command'

module Markdo
  describe SummaryCommand do
    it 'outputs summary counts' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, *rest = build_date_commands_support

      SummaryCommand.new(out, *rest).run

      expect(out.string).to eq(<<-XML)
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
