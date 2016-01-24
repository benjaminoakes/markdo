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
    tag                   Search *.md files for @tag.
    today                 Search *.md files for today's date.  (YYYY-MM-DD format.)
    tomorrow              Search *.md files for tomorrow's date.  (YYYY-MM-DD format.)
    star, starred         Search *.md files for @star.
    query, q              Search *.md files for string.
EOF

      exit 1
    end
  end
end
