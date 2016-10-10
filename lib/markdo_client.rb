require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/markdown_renderer'
require 'markdo/models/task_collection'

module Markdo
  class Client
    def run
      lines = fetch_lines
      task_collection = TaskCollection.new(lines)

      attach_filter('#rb-all-count', task_collection.all)

      attach_filter('#rb-overdue-count', task_collection.due_today)
      attach_filter('#rb-due-today-count', task_collection.due_today)
      attach_filter('#rb-wip-count', task_collection.with_tag('wip'))
      attach_filter('#rb-starred-count', task_collection.starred)

      attach_filter('#rb-due-tomorrow-count', task_collection.due_tomorrow)
      attach_filter('#rb-due-soon-count', task_collection.due_soon)
      attach_filter('#rb-deferred-until-today-count', task_collection.deferred_until_today)
      attach_filter('#rb-next-count', task_collection.with_tag('next'))
    end

    private

    def attach_filter(selector, tasks)
      count_element = Element[selector]
      count_element.html = tasks.count
      
      count_element.closest('a').on(:click) do |event|
        target = event.current_target

        Element['.rb-filter-nav li'].remove_class('active')
        target.closest('li').add_class('active')

        render_tasks(tasks)
      end
    end

    def fetch_lines
      [
        '- [x] Example @star',
        '- [ ] Example @star',
        '- [ ] Example @wip',
        '- [ ] Example @defer(2016-10-01)',
        '- [ ] Example @due(2016-10-09)',
        '- [ ] Example @due(2016-10-10)',
        '- [ ] Example @due(2016-10-11)',
        '- [ ] Example @due(2016-10-12)',
        '- [ ] Example @next',
      ]
    end

    def render_tasks(tasks)
      lines = tasks.map { |task| task.line }
      render_markdown(lines)
    end

    def render_markdown(lines)
      html = MarkdownRenderer.new(lines.join("\n")).to_html
      Element['#rb-markdown-document'].html = html
    end
  end
end

Document.ready? do
  Markdo::Client.new.run
end
