require 'markdo/command'

module Markdo
  class HelpCommand < Command
    def run
      @stderr.puts <<-EOF
Markdown-based task manager.

    add                   Add a task to the inbox.  (Set $MARKDO_ROOT and $MARKDO_INBOX.)
    edit                  Edit $MARKDO_ROOT in $EDITOR.
    help, --help          Display this help text.
    version, --version    Display the version.
    query, q              Search *.md files for string.
EOF

      exit 1
    end
  end
end
