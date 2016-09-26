require 'spec_helper'
require 'stringio'
require 'markdo/commands/inbox_command'

module Markdo
  describe InboxCommand do
    it 'outputs inbox' do
      skip 'File.readlines not supported' unless File.respond_to?(:readlines)

      out = StringIO.new
      err = StringIO.new
      env = {
        'MARKDO_ROOT' => 'test/fixtures/inbox_command',
        'MARKDO_INBOX' => 'inbox.md'
      }

      InboxCommand.new(out, err, env).run

      expect(out.string).to eq(<<-XML)
- [ ] Example 1 in inbox
- [ ] Example 2 in inbox
      XML
    end
  end
end
