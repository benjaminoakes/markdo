require 'markdo/command'
require 'markdo/star_command'
require 'markdo/today_command'
require 'markdo/tomorrow_command'

module Markdo
  class OverviewCommand < Command
    def run
      commands = [StarCommand, TodayCommand, TomorrowCommand]
      
      commands.each do |command|
        command.new(@stdout, @stderr, @env).run
      end
    end
  end
end
