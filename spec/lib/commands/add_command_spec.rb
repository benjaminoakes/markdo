require 'spec_helper'
require 'markdo/commands/add_command'

module Markdo
  describe AddCommand do
    before do
      skip 'Could not access fixtures' unless File.exists?('spec/fixtures/')
    end

    it 'appends to the inbox' do
      clear_inbox
      markdo_add 'Example task'
      expect(read_inbox).to eq([
        '- [ ] Example task',
      ])
      markdo_add 'Another example task'
      expect(read_inbox).to eq([
        '- [ ] Example task',
        '- [ ] Another example task',
      ])
    end

    describe 'given a nil' do
      it 'appends to the inbox' do
        clear_inbox
        markdo_add nil
        assert_inbox_empty
      end
    end

    describe 'given an empty string' do
      it 'appends to the inbox' do
        clear_inbox
        markdo_add ''
        assert_inbox_empty
      end
    end

    describe 'given a blank string' do
      it 'appends to the inbox' do
        clear_inbox
        markdo_add ' '
        assert_inbox_empty
      end
    end

    def clear_inbox
      File.write('spec/fixtures/add_command/Inbox.md', '')
    end

    def read_inbox
      File.
        readlines('spec/fixtures/add_command/Inbox.md').
        map { |line| line.chomp }
    end

    def markdo_add(task_body)
      command_support = build_command_support({
        'MARKDO_ROOT' => 'spec/fixtures/add_command',
        'MARKDO_INBOX' => 'Inbox.md',
      })

      AddCommand.new(command_support).run(task_body)
    end

    def assert_inbox_empty
      expect(read_inbox).to be_empty
    end
  end
end
