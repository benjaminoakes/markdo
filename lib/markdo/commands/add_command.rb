require 'markdo/commands/command'

module Markdo
  class AddCommand < Command
    def run(task)
      task = String(task)

      unless task.strip.empty?
        File.open(inbox_path, 'a') do |file|
          file.puts(template(task))
        end
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
