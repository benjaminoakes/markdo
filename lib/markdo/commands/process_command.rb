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
          choice = prompt(current_line)

          case choice
          when 'h'
            HelpSubcommand.new(@command_support).run
          when 'i'
            @lines_by_filename['Inbox.md'] <<= current_line
            @line_index += 1
          when 's'
            @lines_by_filename['Sprint.md'] <<= current_line
            @line_index += 1
          when 'b'
            @lines_by_filename['Backlog.md'] <<= current_line
            @line_index += 1
          when 'm'
            @lines_by_filename['Maybe.md'] <<= current_line
            @line_index += 1
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

    def current_line
      @lines[@line_index]
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

    class HelpSubcommand < Command
      def run
        @stdout.puts 'i - inbox (keep in inbox)'
        @stdout.puts 's - sprint'
        @stdout.puts 'b - backlog'
        @stdout.puts 'm - maybe'
        @stdout.puts 'a - abort; make no changes'
      end
    end
  end
end
