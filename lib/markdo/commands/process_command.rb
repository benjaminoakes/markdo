require 'date'
require 'markdo/commands/command'

module Markdo
  class ProcessCommand < Command
    def initialize(*)
      super
      @lines_by_filename = Hash.new { [] }
      @lines = File.readlines(data_source.inbox_path)
      @line_index = 0
    end

    def run
      catch :abort do
        while has_lines?
          line = @lines[@line_index]
          choice = prompt(line)

          case choice
          when 'h'
            show_help
          when 'i'
            move_line_to('Inbox.md', line)
          when 's'
            move_line_to('Sprint.md', line)
          when 'b'
            move_line_to('Backlog.md', line)
          when 'm'
            move_line_to('Maybe.md', line)
          when 'a'
            throw :abort
          end
        end

        write_files
      end
    end

    private

    def file_path(filename)
      File.join(@env['MARKDO_ROOT'], filename)
    end

    def has_lines?
      @line_index < @lines.length
    end

    def prompt(line)
      @stdout.puts line
      @stdout.print 'File [hisbma]? '

      input_line = @stdin.gets

      @stdout.puts

      if input_line.nil?
        throw :abort
      else
        input_line.chomp.downcase
      end
    end

    def move_line_to(filename, line)
      @lines_by_filename[filename] <<= line
      @line_index += 1
    end

    def write_files
      inbox_lines = @lines_by_filename.delete('Inbox.md')
      File.write(data_source.inbox_path, inbox_lines ? inbox_lines.join : '')

      @lines_by_filename.each do |filename, lines|
        path = file_path(filename)
        new_content = ["\n## Processed on #{@today.iso8601}\n\n"] << lines

        File.open(path, 'a') do |file|
          file.puts(new_content.join)
        end
      end
    end

    def show_help
      @stdout.puts 'i - inbox (keep in inbox)'
      @stdout.puts 's - sprint'
      @stdout.puts 'b - backlog'
      @stdout.puts 'm - maybe'
      @stdout.puts 'a - abort; make no changes'
    end
  end
end
