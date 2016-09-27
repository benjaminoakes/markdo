require 'spec_helper'
require 'stringio'
require 'markdo/commands/summary_command'

module Markdo
  describe SummaryCommand do
    it 'outputs summary counts' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, err = build_command_support
      env = {
        'MARKDO_ROOT' => 'spec/fixtures/date_commands',
        'MARKDO_INBOX' => 'inbox.md'
      }

      SummaryCommand.new(out, err, env, Date.new(2016, 2, 28)).run

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
