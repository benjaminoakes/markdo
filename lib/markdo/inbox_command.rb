require 'markdo/command'

module Markdo
  class InboxCommand < Command
    def run
      @stdout.puts(File.read(inbox_path))
    end

    protected

    def inbox_path
      File.join(@env['MARKDO_ROOT'], @env['MARKDO_INBOX'])
    end
  end
end
