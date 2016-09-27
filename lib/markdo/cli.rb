require 'markdo/commands'

module Markdo
  class CLI
    def initialize(stdout, stderr, full_env)
      @stdout = stdout
      @stderr = stderr
      @full_env = full_env
    end

    def run(command_name = 'help', *args)
      command = case command_name
                when 'add'
                  AddCommand
                when 'edit'
                  EditCommand
                when 'forecast'
                  ForecastCommand
                when 'ics'
                  IcsCommand
                when 'inbox'
                  InboxCommand
                when 'overdue'
                  OverdueCommand
                when 'overview'
                  OverviewCommand
                when 'process'
                  ProcessCommand
                when 'query', 'q'
                  QueryCommand
                when 'star', 'starred'
                  StarCommand
                when 'summary'
                  SummaryCommand
                when 'tag'
                  TagCommand
                when 'today'
                  TodayCommand
                when 'tomorrow'
                  TomorrowCommand
                when 'version', '--version'
                  VersionCommand
                when 'week'
                  WeekCommand
                else
                  HelpCommand
                end

      command.new(@stdout, @stderr, env).run(*args)
    end

    private

    def default_env
      {
        'MARKDO_ROOT' => '.',
        'MARKDO_INBOX' => 'Inbox.md',
      }
    end

    def env
      default_env.merge(@full_env)
    end
  end
end
