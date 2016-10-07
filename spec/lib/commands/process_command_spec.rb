require 'spec_helper'
require 'markdo/commands/process_command'

module Markdo
  describe ProcessCommand do
    before do
      skip 'Could not access fixtures' unless File.exists?('spec/fixtures/')
    end

    after do
      write_inbox([])
    end

    describe 'given the "h" subcommand' do
      it 'prints help to stdout and makes no changes' do
        original_content = ['- [ ] Example']
        write_inbox(original_content)

        stdout = markdo_process(%w(h h))

        expect(stdout.string).to eq(<<-EOF)
- [ ] Example
File [hisbma]? 
i - inbox (keep in inbox)
s - sprint
b - backlog
m - maybe
a - abort; make no changes
- [ ] Example
File [hisbma]? 
i - inbox (keep in inbox)
s - sprint
b - backlog
m - maybe
a - abort; make no changes
- [ ] Example
File [hisbma]? 
        EOF
        
        expect(read_inbox).to eq(original_content)
      end
    end

    def write_inbox(content)
      File.write('spec/fixtures/process_command/Inbox.md', content.join("\n"))
    end

    def markdo_process(subcommands)
      command_support = build_command_support({
        'MARKDO_ROOT' => 'spec/fixtures/process_command',
        'MARKDO_INBOX' => 'Inbox.md',
      })
      raw_input = subcommands.map { |s| "#{s}\n" }.join
      command_support.stdin = StringIO.new(raw_input)

      ProcessCommand.new(command_support).run

      command_support.stdout
    end

    def read_inbox
      File.
        readlines('spec/fixtures/process_command/Inbox.md').
        map { |line| line.chomp }
    end
  end
end
