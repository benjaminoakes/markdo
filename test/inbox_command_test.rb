require 'test_helper'
require 'markdo/inbox_command'

module Markdo
  describe InboxCommand do
    it 'outputs inbox' do
      out = StringIO.new
      err = StringIO.new
      env = { 'MARKDO_ROOT' => 'test/fixtures', 'MARKDO_INBOX' => 'inbox.md' }

      InboxCommand.new(out, err, env).run

      out.string.must_equal <<-XML
- [ ] Test 1
- [ ] Test 2
      XML
    end
  end
end
