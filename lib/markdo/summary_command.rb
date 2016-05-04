require 'stringio'

require 'markdo/command'
require 'markdo/overdue_command'
require 'markdo/star_command'
require 'markdo/today_command'
require 'markdo/tomorrow_command'

module Markdo
  class SummaryCommand < Command
    def run
      commands = [OverdueCommand, StarCommand, TodayCommand, TomorrowCommand]

      commands.each do |command|
        out = StringIO.new
        command.new(out, @stderr, @env).run

        title = command.to_s.sub(/^Markdo::/, '').sub(/Command$/, '')
        lines = out.string.split("\n")
        sum =  lines.length.inspect

        @stdout.puts("#{title}: #{sum}")
      end
    end
  end
end
