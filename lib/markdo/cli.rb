require 'markdo/add_command'
require 'markdo/edit_command'
require 'markdo/help_command'
require 'markdo/ics_command'
require 'markdo/overview_command'
require 'markdo/query_command'
require 'markdo/rss_command'
require 'markdo/star_command'
require 'markdo/summary_command'
require 'markdo/tag_command'
require 'markdo/today_command'
require 'markdo/tomorrow_command'
require 'markdo/version_command'

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
                when 'ics'
                  IcsCommand
                when 'overdue'
                  OverdueCommand
                when 'overview'
                  OverviewCommand
                when 'query', 'q'
                  QueryCommand
                when 'rss'
                  RssCommand
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
