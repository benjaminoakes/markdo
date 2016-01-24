require 'markdo/help_command'
require 'markdo/version_command'

module Markdo
  class CLI
    def initialize(stdout, stderr)
      @stdout = stdout
      @stderr = stderr
    end

    def run(command_name = 'help')
      case command_name
      when 'version', '--version'
        VersionCommand.new(@stdout, @stderr).run
      else
        HelpCommand.new(@stdout, @stderr).run
      end
    end
  end
end
