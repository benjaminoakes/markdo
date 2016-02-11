require 'markdo/command'

module Markdo
  class HelpCommand < Command
    def run
      @stderr.puts <<-EOF
Markdown-based task manager.

    add "string"          Add a task to the inbox.  (Set $MARKDO_ROOT and $MARKDO_INBOX.)
    edit                  Edit $MARKDO_ROOT in $EDITOR.
    help, --help          Display this help text.
    overview              Get overview of overdue, starred, today's, and tomorrow's tasks.
    overdue               Search *.md files for previous dates.  (YYYY-MM-DD format.)
    tag "string"          Search *.md files for @string.
    today                 Search *.md files for today's date.  (YYYY-MM-DD format.)
    tomorrow              Search *.md files for tomorrow's date.  (YYYY-MM-DD format.)
    rss                   Make an RSS feed of all links in Markdo.  Useful as a live bookmark.
    star, starred         Search *.md files for @star.
    query, q "string"     Search *.md files for string.
    version, --version    Display the version.
EOF

      exit 1
    end
  end
end
