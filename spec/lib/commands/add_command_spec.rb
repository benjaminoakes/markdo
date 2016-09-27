require 'spec_helper'
require 'stringio'
require 'markdo/commands/add_command'

module Markdo
  describe AddCommand do
    it 'appends to the inbox' do
      skip 'Could not access fixtures' unless File.exists?('spec/fixtures/')

      out, err = build_command_support
      env = {
        'MARKDO_ROOT' => 'spec/fixtures/add_command',
        'MARKDO_INBOX' => 'inbox.md',
      }

      File.write('spec/fixtures/add_command/inbox.md', '')
      AddCommand.new(out, err, env).run('Example Task')
      content = File.read('spec/fixtures/add_command/inbox.md')
      expect(content).to eq("- [ ] Example Task\n")
    end

    describe 'given a nil' do
      it 'appends to the inbox' do
        skip 'Could not access fixtures' unless File.exists?('spec/fixtures/')

        out, err = build_command_support
        env = {
          'MARKDO_ROOT' => 'spec/fixtures/add_command',
          'MARKDO_INBOX' => 'inbox.md',
        }

        File.write('spec/fixtures/add_command/inbox.md', '')
        AddCommand.new(out, err, env).run(nil)
        content = File.read('spec/fixtures/add_command/inbox.md')
        expect(content).to eq('')
      end
    end

    describe 'given an empty string' do
      it 'appends to the inbox' do
        skip 'Could not access fixtures' unless File.exists?('spec/fixtures/')

        out, err = build_command_support
        env = {
          'MARKDO_ROOT' => 'spec/fixtures/add_command',
          'MARKDO_INBOX' => 'inbox.md',
        }

        File.write('spec/fixtures/add_command/inbox.md', '')
        AddCommand.new(out, err, env).run('')
        content = File.read('spec/fixtures/add_command/inbox.md')
        expect(content).to eq('')
      end
    end

    describe 'given a blank string' do
      it 'appends to the inbox' do
        skip 'Could not access fixtures' unless File.exists?('spec/fixtures/')

        out, err = build_command_support
        env = {
          'MARKDO_ROOT' => 'spec/fixtures/add_command',
          'MARKDO_INBOX' => 'inbox.md',
        }

        File.write('spec/fixtures/add_command/inbox.md', '')
        AddCommand.new(out, err, env).run(' ')
        content = File.read('spec/fixtures/add_command/inbox.md')
        expect(content).to eq('')
      end
    end
  end
end
