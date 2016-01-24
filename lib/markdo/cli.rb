require 'markdo/version_command'

module Markdo
  class CLI
    def initialize(stdout, stderr)
      @stdout = stdout
      @stderr = stderr
    end

    def run(command_name)
      case command_name
      when 'version', '--version'
        VersionCommand.new(@stdout, @stderr).run
      end
    end
  end
end
