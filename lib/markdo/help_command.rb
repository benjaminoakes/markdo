require 'markdo/command'

module Markdo
  class HelpCommand < Command
    def run
      @stderr.puts <<-EOF
Markdown-based task manager.

    help, --help          Display this help text.
    version, --version    Display the version.
EOF

      exit 1
    end
  end
end
