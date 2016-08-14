require 'markdo/command'

module Markdo
  class HelpCommand < Command
    def run
      @stderr.puts <<-EOF
Markdown-based task manager.

    add "string"          Add a task to the inbox.  (Set $MARKDO_ROOT and $MARKDO_INBOX.)
    edit                  Edit $MARKDO_ROOT in $EDITOR.
    forecast              Display counts of dates in the next week.  (YYYY-MM-DD format.)
    help, --help          Display this help text.
    inbox                 Display contents of $MARKDO_INBOX.
    ics                   Make an iCalendar feed of all due dates in Markdo.  Can be imported
                          or subscribed to if on a remote server.
    overview              Get overview of overdue, starred, today's, and tomorrow's tasks.
    overdue               Search *.md files for previous dates.  (YYYY-MM-DD format.)
    process               Move lines from $MARKDO_INBOX to other files, one at a time.
    tag "string"          Search *.md files for @string.
    today                 Search *.md files for today's date.  (YYYY-MM-DD format.)
    tomorrow              Search *.md files for tomorrow's date.  (YYYY-MM-DD format.)
    rss                   Make an RSS feed of all links in Markdo.  Useful as a live bookmark.
    star, starred         Search *.md files for @star.
    summary               Display counts.
    query, q "string"     Search *.md files for string.
    week                  Search *.md files for dates in the next week.  (YYYY-MM-DD format.)
    version, --version    Display the version.
EOF

      exit 1
    end
  end
end
