require 'markdo/commands/command'

module Markdo
  class AddCommand < Command
    def run(task)
      task = String(task)

      unless task.strip.empty?
        File.open(data_source.inbox_path, 'a') do |file|
          file.puts(template(task))
        end
      end
    end

    protected

    def template(task)
      "- [ ] #{task}"
    end
  end
end
