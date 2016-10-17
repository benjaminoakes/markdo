require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/config'
require 'markdo/markdown_renderer'
require 'markdo/models/task_collection'

module Markdo
  class Client
    def initialize
      @markdown_view = MarkdownView.new(Element['#rb-markdown-document'])
      @navigation_view = NavigationView.new(Element['#rb-nav'])
    end

    def run
      @navigation_view.render

      attach_nav_selector

      fetch_markdown_lines.then do |lines|
        task_collection = TaskCollection.new(lines)

        fetch_config.then do |config|
          config.tags.each do |tag|
            append_and_attach_tag_filter(tag, task_collection)
          end
        end

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

        @navigation_view.activate(target)

        @markdown_view.show
        Element['#rb-back-button'].remove_class('hidden-xs')
        @navigation_view.hide

        Element['#rb-document-heading'].html = target.html

        render_tasks(tasks)
      end
    end

    def attach_back_button
      Element['#rb-back-button'].on(:click) do |event|
        event.prevent_default

        Element['#rb-back-button'].add_class('hidden-xs')
        @markdown_view.hide
        @navigation_view.show
      end
    end

    def append_and_attach_tag_filter(tag, task_collection)
      id = "rb-#{tag}-count"
      new_filter = %Q(<li role="presentation"><a href="#"><span class="badge" id="#{id}"></span> #{tag}</a></li>)
      Element['#rb-tag-nav ul'].append(new_filter)
      attach_filter("##{id}", task_collection.with_tag(tag))
    end

    def fetch_config
      cache_breaker = Time.now.to_i
      promise = Promise.new

      HTTP.get("data/config.json?#{cache_breaker}") do |response|
        config = Config.new

        if 200 == response.status_code
          config.tags = response.json['tags']
          promise.resolve(config)
        else
          config.tags = example_tags
          promise.resolve(config)
        end
      end

      promise
    end

    def fetch_markdown_lines
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

    def example_tags
      %w[downtown shopping]
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
      @markdown_view.render(lines.join("\n"))
    end
  end

  class MarkdownView
    def initialize(element)
      @element = element
    end

    def render(markdown)
      html = MarkdownRenderer.new(markdown).to_html

      @element.html = html
      @element.find('a').attr('target', '_blank')
    end

    def show
      @element.remove_class('hidden-xs')
    end

    def hide
      @element.add_class('hidden-xs')
      @element.html = ''
    end
  end

  class NavigationView
    def initialize(element)
      @element = element
    end

    def render
      @element.on(:click) do |event|
        event.prevent_default
      end
    end

    def show
      deactivate_all
      @element.remove_class('hidden-xs')
    end

    def hide
      @element.add_class('hidden-xs')
    end

    def activate(target)
      deactivate_all
      target.closest('li').add_class('active')
    end

    private

    def deactivate_all
      @element.find('li').remove_class('active')
    end
  end
end

Document.ready? do
  Markdo::Client.new.run
end
