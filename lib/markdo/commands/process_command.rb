require 'date'
require 'markdo/commands/command'

module Markdo
  class ProcessCommand < Command
    # Built as a prototype/proof of concept to see how much I like this idea...
    def run
      lines = File.readlines(data_source.inbox_path)
      lines_by_filename = Hash.new { [] }

      index = 0

      catch :abort do
        while index < lines.length
          line = lines[index]
          @stdout.puts line
          @stdout.print 'File [hisbma]? '

          input_line = @stdin.gets

          @stdout.puts

          if input_line.nil?
            throw :abort
          else
            choice = input_line.chomp.downcase
          end

          case choice
          when 'h'
            @stdout.puts 'i - inbox (keep in inbox)'
            @stdout.puts 's - sprint'
            @stdout.puts 'b - backlog'
            @stdout.puts 'm - maybe'
            @stdout.puts 'a - abort; make no changes'
          when 'i'
            lines_by_filename['Inbox.md'] <<= line
            index += 1
          when 's'
            lines_by_filename['Sprint.md'] <<= line
            index += 1
          when 'b'
            lines_by_filename['Backlog.md'] <<= line
            index += 1
          when 'm'
            lines_by_filename['Maybe.md'] <<= line
            index += 1
          when 'a'
            throw :abort
          end
        end

        date = @today.iso8601
        inbox_lines = lines_by_filename.delete('Inbox.md')
        File.write(data_source.inbox_path, inbox_lines ? inbox_lines.join : '')

        lines_by_filename.each do |filename, lines|
          path = file_path(filename)
          new_content = ["\n## Processed on #{date}\n\n"] << lines

          File.open(path, 'a') do |file|
            file.puts(new_content.join)
          end
        end
      end
    end

    private

    def file_path(filename)
      File.join(@env['MARKDO_ROOT'], filename)
    end
  end
end
