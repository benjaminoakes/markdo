require 'markdo/commands/command'
require 'markdo/commands/overdue_command'
require 'markdo/commands/star_command'
require 'markdo/commands/today_command'
require 'markdo/commands/tomorrow_command'

module Markdo
  class OverviewCommand < Command
    def run
      commands = [OverdueCommand, StarCommand, TodayCommand, TomorrowCommand]
      
      commands.each do |command|
        command.new(@stdout, @stderr, @env, @reference_date).run
      end
    end
  end
end
