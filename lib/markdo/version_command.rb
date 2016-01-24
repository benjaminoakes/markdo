require 'markdo/version'

module Markdo
  class VersionCommand
    def initialize(stdout, stderr)
      @stdout = stdout
      @stderr = stderr
    end

    def run
      @stdout.puts("v#{Markdo::VERSION}")
    end
  end
end
