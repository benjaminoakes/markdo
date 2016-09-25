require 'test_helper'
require 'markdo/summary_command'

module Markdo
  describe SummaryCommand do
    it 'outputs summary counts' do
      out = StringIO.new
      err = StringIO.new
      env = { 'MARKDO_ROOT' => 'test/fixtures', 'MARKDO_INBOX' => 'inbox.md' }

      SummaryCommand.new(out, err, env).run

      out.string.must_equal <<-XML
Overdue: 4
Inbox: 2
      XML
    end
  end
end
