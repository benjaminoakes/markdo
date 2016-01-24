require 'markdo/command'

module Markdo
  class AddCommand < Command
    def run(task)
      File.open(inbox_path, 'a') do |file|
        file.puts(template(task))
      end
    end

    protected

    def template(task)
      "- [ ] #{task}"
    end

    def inbox_path
      File.join(@env['MARKDO_ROOT'], @env['MARKDO_INBOX'])
    end
  end
end
