require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/markdown_renderer'
require 'markdo/models/task_collection'

module Markdo
  class Client
    def run
      Element['#rb-nav'].on(:click) do |event|
        event.prevent_default
      end

      attach_nav_selector

      fetch_lines.then do |lines|
        task_collection = TaskCollection.new(lines)

        attach_filter('#rb-all-count', task_collection.all)
        attach_filter('#rb-complete-count', task_collection.complete)

        attach_filter('#rb-overdue-count', task_collection.overdue)
        attach_filter('#rb-due-today-count', task_collection.due_today)
        attach_filter('#rb-wip-count', task_collection.with_tag('wip'))
        attach_filter('#rb-starred-count', task_collection.starred)

        attach_filter('#rb-waiting-count', task_collection.with_tag('waiting'))
        attach_filter('#rb-due-tomorrow-count', task_collection.due_tomorrow)
        attach_filter('#rb-due-soon-count', task_collection.due_soon)
        attach_filter('#rb-deferred-until-today-count', task_collection.deferred_until_today)
        attach_filter('#rb-next-count', task_collection.with_tag('next'))

        attach_filter('#rb-downtown-count', task_collection.with_tag('downtown'))
        attach_filter('#rb-shopping-count', task_collection.with_tag('shopping'))

        attach_back_button
      end
    end

    private

    def attach_nav_selector
      Element['#rb-nav-selector a'].on(:click) do |event|
        target = event.target.closest('a')
        show_selector = target.attr('data-show-selector')
        hide_selector = target.attr('data-hide-selector')

        Element['#rb-nav-selector a'].remove_class('active')
        target.add_class('active')

        Element[show_selector].remove_class('hidden')
        Element[hide_selector].add_class('hidden')
      end
    end

    def attach_filter(selector, tasks)
      count_element = Element[selector]
      count_element.html = tasks.count
      
      count_element.closest('a').on(:click) do |event|
        target = event.current_target

        Element['#rb-nav li'].remove_class('active')
        target.closest('li').add_class('active')

        Element['#rb-markdown-document'].remove_class('hidden-xs')
        Element['#rb-back-button'].remove_class('hidden-xs')
        Element['#rb-nav'].add_class('hidden-xs')

        Element['#rb-document-heading'].html = target.html

        render_tasks(tasks)
      end
    end

    def attach_back_button
      Element['#rb-back-button'].on(:click) do |event|
        event.prevent_default

        Element['#rb-back-button'].add_class('hidden-xs')
        Element['#rb-markdown-document'].add_class('hidden-xs')
        Element['#rb-markdown-document'].html = ''
        Element['#rb-nav li'].remove_class('active')
        Element['#rb-nav'].remove_class('hidden-xs')
      end
    end

    def fetch_lines
      cache_breaker = Time.now.to_i
      promise = Promise.new

      HTTP.get("data/__all__.md?#{cache_breaker}") do |response|
        markdown = response.body

        if 200 == response.status_code
          lines = markdown.split("\n")
          promise.resolve(lines)
        else
          promise.resolve(example_lines)
        end
      end

      promise
    end

    def example_lines
      [
        '# Example',
        '',
        'Any Markdown you want',
        '',
        '## Like headings',
        '',
        '### And subheadings',
        '',
        '> Quoted text.',
        '',
        'And of course:',
        '',
        '- [x] A completed task',
        '- [ ] An incomplete task',
        '- [ ] @due(2016-01-01) A task with a due date',
        '- [ ] A task with a tag @downtown',
        '- [ ] A starred task @star',
        '- [ ] A work-in-progress task @wip',
        '- [ ] A deferred task @defer(2016-10-01)',
        '- [ ] A task I want to do soon @next',
      ]
    end

    def render_tasks(tasks)
      lines = tasks.map { |task| task.line }
      render_markdown(lines.join("\n"))
    end

    def render_markdown(markdown)
      html = MarkdownRenderer.new(markdown).to_html
      Element['#rb-markdown-document'].html = html

      Element['#rb-markdown-document a'].attr('target', '_blank')
    end
  end
end

Document.ready? do
  Markdo::Client.new.run
end
