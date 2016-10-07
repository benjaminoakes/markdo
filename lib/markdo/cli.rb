require 'markdo/commands'

module Markdo
  class CLI
    def initialize(command_support = CommandSupport.new)
      @stdout = command_support.stdout
      @stderr = command_support.stderr
      @full_env = command_support.env
    end

    def run(command_name = 'help', *args)
      command = case command_name
                when 'q'
                  QueryCommand
                when 'starred'
                  StarCommand
                when '--version'
                  VersionCommand
                else
                  choose_command_class(command_name)
                end

      command_support = CommandSupport.new(stdout: @stdout,
                                           stderr: @stderr,
                                           env: merged_env)
      command.new(command_support).run(*args)
    end

    private

    def choose_command_class(command_name)
      command_class_name = "#{command_name.capitalize}Command"
      ::Markdo.const_get(command_class_name)
    rescue NameError
      HelpCommand
    end

    def default_env
      {
        'MARKDO_ROOT' => '.',
        'MARKDO_INBOX' => 'Inbox.md',
      }
    end

    def merged_env
      default_env.merge(@full_env)
    end
  end
end
