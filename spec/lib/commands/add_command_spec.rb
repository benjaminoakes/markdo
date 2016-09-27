require 'spec_helper'
require 'stringio'
require 'markdo/commands/add_command'

module Markdo
  describe AddCommand do
    before do
      skip 'Could not access fixtures' unless File.exists?('spec/fixtures/')
    end

    it 'appends to the inbox' do
      clear_inbox
      markdo_add 'Example Task'
      expect(read_inbox).to eq("- [ ] Example Task\n")
    end

    describe 'given a nil' do
      it 'appends to the inbox' do
        clear_inbox
        markdo_add nil
        expect(read_inbox).to eq('')
      end
    end

    describe 'given an empty string' do
      it 'appends to the inbox' do
        clear_inbox
        markdo_add ''
        expect(read_inbox).to eq('')
      end
    end

    describe 'given a blank string' do
      it 'appends to the inbox' do
        clear_inbox
        markdo_add ' '
        expect(read_inbox).to eq('')
      end
    end

    def clear_inbox
      File.write('spec/fixtures/add_command/inbox.md', '')
    end

    def read_inbox
      File.read('spec/fixtures/add_command/inbox.md')
    end

    def markdo_add(task_body)
      out, err = build_command_support
      env = {
        'MARKDO_ROOT' => 'spec/fixtures/add_command',
        'MARKDO_INBOX' => 'inbox.md',
      }

      AddCommand.new(out, err, env).run(task_body)
    end
  end
end
