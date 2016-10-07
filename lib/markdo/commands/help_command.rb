require 'markdo/commands/command'

module Markdo
  class HelpCommand < Command
    def run
      @stderr.puts <<-EOF
Markdown-based task manager.

    add "string"          Add a task to the inbox.  (Set $MARKDO_ROOT and $MARKDO_INBOX.)
    edit                  Edit $MARKDO_ROOT in $EDITOR.
    forecast              Display tasks due in the next week.  (@due(YYYY-MM-DD) format.)
    help, --help          Display this help text.
    inbox                 Display contents of $MARKDO_INBOX.
    ics                   Make an iCalendar feed of all due dates in Markdo.  Can be imported
                          or subscribed to if on a remote server.
    overview              Get overview of overdue, starred, today's, and tomorrow's tasks.
    overdue               Search *.md files for tasks due on previous dates.  (@due(YYYY-MM-DD) format.)
    process               Move lines from $MARKDO_INBOX to other files, one at a time.
    tag "string"          Search *.md files for @string.
    today                 Search *.md files for tasks due today.  (@due(YYYY-MM-DD) format.)
    tomorrow              Search *.md files for tasks due tomorrow.  (@due(YYYY-MM-DD) format.)
    star, starred         Search *.md files for @star.
    summary               Display counts.
    query, q "string"     Search *.md files for string.
    week                  Search *.md files for due dates in the next week.  (@due(YYYY-MM-DD) format.)
    version, --version    Display the version.
EOF

      Kernel.exit(1)
    end
  end
end
