require 'test_helper'
require 'markdo/commands/summary_command'

module Markdo
  describe SummaryCommand do
    it 'outputs summary counts' do
      out = StringIO.new
      err = StringIO.new
      env = {
        'MARKDO_ROOT' => 'test/fixtures/summary_command',
        'MARKDO_INBOX' => 'inbox.md'
      }

      SummaryCommand.new(out, err, env, Date.new(2016, 2, 28)).run

      out.string.must_equal <<-XML
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
