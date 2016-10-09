# Markdo

[![Build Status](https://travis-ci.org/benjaminoakes/markdo.svg?branch=master)](https://travis-ci.org/benjaminoakes/markdo)

Markdown-based task manager.  Inspired by [OmniFocus][omnifocus], [TaskPaper][taskpaper], and [GitHub Flavored Markdown's task lists][gfm-task-lists].

  [gfm-task-lists]: https://github.com/blog/1375-task-lists-in-gfm-issues-pulls-comments
  [omnifocus]: https://www.omnigroup.com/omnifocus/
  [taskpaper]: http://www.hogbaysoftware.com/products/taskpaper

## Installation

Install Ruby, and then:

    gem install markdo

## Usage

You might already be using Markdo-formatted text already!

Basically, you write Markdown, and use the GFM "task list" syntax:

```
# Example

Any Markdown you want

## Like headings

## And subheadings

> Quoted text.

And of course:

- [x] A completed task
- [ ] An incomplete task
  - [ ] A subtask
- [ ] @due(2016-01-01) A task with a due date
- [ ] A task with a @tag
```

Then you can use `markdo` to interact with your files.

See `markdo help` for more information.

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Development Environment

```
docker-compose build
docker-compose run guard # run tests interactively
docker-compose run build # build the gem
```
