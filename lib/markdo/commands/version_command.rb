require 'markdo/commands/command'
require 'markdo/version'

module Markdo
  class VersionCommand < Command
    def run
      @stdout.puts("v#{Markdo::VERSION}")
    end
  end
end
