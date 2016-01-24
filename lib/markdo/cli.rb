require 'markdo/add_command'
require 'markdo/help_command'
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
