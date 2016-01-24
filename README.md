# Markdo

Markdown-based task manager.  Inspired by OmniFocus and GitHub Flavored Markdown's task lists.

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
- [ ] 2016-01-01 A task with a date
- [ ] A task with a @tag
```

Then you can use `markdo` to interact with your files.

See `markdo help` for more information.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
