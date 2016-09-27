require 'shellwords'
require 'markdo/commands/command'

module Markdo
  class EditCommand < Command
    def run
      system("#{@env['EDITOR']} #{safe_markdo_root}")
    end

    private

    def safe_markdo_root
      Shellwords.shellescape(@env['MARKDO_ROOT'])
    end
  end
end
