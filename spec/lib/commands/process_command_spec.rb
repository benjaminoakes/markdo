require 'spec_helper'
require 'markdo/commands/process_command'

module Markdo
  describe ProcessCommand do
    before do
      skip 'Could not access fixtures' unless File.exists?('spec/fixtures/')
    end

    after do
      clear_all
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
        
        expect(read_lines('Inbox')).to eq(original_content)
        expect(read_lines('Sprint')).to eq([])
        expect(read_lines('Backlog')).to eq([])
        expect(read_lines('Maybe')).to eq([])
      end
    end
    
    describe 'given the "i" subcommand' do
      it 'keeps the task in the inbox' do
        original_content = ['- [ ] Example']
        write_inbox(original_content)

        stdout = markdo_process(%w(i))

        assert_prompt_shown(stdout)
        expect(read_lines('Inbox')).to eq(original_content)
        expect(read_lines('Sprint')).to eq([])
        expect(read_lines('Backlog')).to eq([])
        expect(read_lines('Maybe')).to eq([])
      end
    end

    describe 'given the "a" subcommand' do
      it 'makes no changes' do
        original_content = ['- [ ] Example']
        write_inbox(original_content)

        stdout = markdo_process(%w(a))

        assert_prompt_shown(stdout)
        expect(read_lines('Inbox')).to eq(original_content)
        expect(read_lines('Sprint')).to eq([])
        expect(read_lines('Backlog')).to eq([])
        expect(read_lines('Maybe')).to eq([])
      end
    end

    describe 'given the "s" subcommand' do
      it 'moves the line to "Sprint.md"' do
        write_inbox(['- [ ] Example'])

        stdout = markdo_process(%w(s))

        assert_prompt_shown(stdout)
        expect(read_lines('Inbox')).to eq([])
        expect(read_lines('Sprint')).to eq([
          '',
          '## Processed on 2016-06-01',
          '',
          '- [ ] Example'
        ])
        expect(read_lines('Backlog')).to eq([])
        expect(read_lines('Maybe')).to eq([])
      end
    end

    describe 'given the "b" subcommand' do
      it 'moves the line to "Backlog.md"' do
        write_inbox(['- [ ] Example'])

        stdout = markdo_process(%w(b))

        assert_prompt_shown(stdout)
        expect(read_lines('Inbox')).to eq([])
        expect(read_lines('Sprint')).to eq([])
        expect(read_lines('Backlog')).to eq([
          '',
          '## Processed on 2016-06-01',
          '',
          '- [ ] Example'
        ])
        expect(read_lines('Maybe')).to eq([])
      end
    end

    describe 'given the "m" subcommand' do
      it 'moves the line to "Maybe.md"' do
        write_inbox(['- [ ] Example'])

        stdout = markdo_process(%w(m))

        assert_prompt_shown(stdout)
        expect(read_lines('Inbox')).to eq([])
        expect(read_lines('Sprint')).to eq([])
        expect(read_lines('Backlog')).to eq([])
        expect(read_lines('Maybe')).to eq([
          '',
          '## Processed on 2016-06-01',
          '',
          '- [ ] Example'
        ])
      end
    end

    def clear_all
      %w(Backlog Inbox Maybe Sprint).each do |filename|
        File.write("spec/fixtures/process_command/#{filename}.md", '')
      end
    end

    def write_inbox(content)
      File.write('spec/fixtures/process_command/Inbox.md', content.join("\n"))
    end

    def markdo_process(subcommands)
      raw_input = subcommands.map { |s| "#{s}\n" }.join
      stdin = StringIO.new(raw_input)
      stdout = StringIO.new
      stderr = StringIO.new
      today = Date.new(2016, 6, 1)
      env = {
        'MARKDO_ROOT' => 'spec/fixtures/process_command',
        'MARKDO_INBOX' => 'Inbox.md',
      }
      command_support = CommandSupport.new(stdin: stdin,
                                           stdout: stdout,
                                           stderr: stderr,
                                           today: today,
                                           env: env)

      ProcessCommand.new(command_support).run

      command_support.stdout
    end

    def read_lines(filename)
      File.
        readlines("spec/fixtures/process_command/#{filename}.md").
        map { |line| line.chomp }
    end

    def assert_prompt_shown(io)
      expect(io.string).to eq(<<-EOF)
- [ ] Example
File [hisbma]? 
      EOF
    end
  end
end
