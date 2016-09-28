require 'spec_helper'
require 'markdo/commands/inbox_command'

module Markdo
  describe InboxCommand do
    it 'outputs inbox' do
      skip 'File.readlines not supported' unless File.respond_to?(:readlines)

      out, err = build_command_support
      env = {
        'MARKDO_ROOT' => 'spec/fixtures/inbox_command',
        'MARKDO_INBOX' => 'Inbox.md'
      }

      InboxCommand.new(out, err, env).run

      expect(out.string).to eq(<<-XML)
- [ ] Example 1 in inbox
- [ ] Example 2 in inbox
      XML
    end
  end
end
