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
      @markdown_view = MarkdownView.new(Element['#rb-markdown-document'], Element['#rb-document-heading'])
      @navigation_view = NavigationView.new(Element['#rb-nav'])
      @back_button_mediator = BackButtonMediator.new(Element['#rb-back-button'], @navigation_view, @markdown_view)
    end

    def run
      @navigation_view.render
      @back_button_mediator.render

      BrowserDataSource.fetch_lines_from_all.then do |lines|
        task_collection = TaskCollection.new(lines)

        BrowserDataSource.fetch_config.then do |config|
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
      end
    end

    private

    def attach_filter(selector, tasks)
      count_element = Element[selector]
      count_element.html = tasks.count
      
      count_element.closest('a').on(:click) do |event|
        target = event.current_target

        @navigation_view.activate(target)
        @back_button_mediator.show

        render_tasks(tasks, target.html)
      end
    end

    def append_and_attach_tag_filter(tag, task_collection)
      id = "rb-#{tag}-count"
      new_filter = %Q(<li role="presentation"><a href="#"><span class="badge" id="#{id}"></span> #{tag}</a></li>)
      Element['#rb-tag-nav ul'].append(new_filter)
      attach_filter("##{id}", task_collection.with_tag(tag))
    end

    def render_tasks(tasks, heading_html)
      lines = tasks.map { |task| task.line }
      @markdown_view.render(lines.join("\n"), heading_html)
    end
  end

  module BrowserDataSource
    class << self
      def fetch_lines_from_all
        Promise.new.tap do |promise|
          get('data/__all__.md').then do |response|
            markdown = response.body
            lines = markdown.split("\n")
            promise.resolve(lines)
          end.fail do
            promise.resolve(example_lines)
          end
        end
      end

      def fetch_config
        config = Config.new

        Promise.new.tap do |promise|
          get('data/config.json').then do |response|
            config.tags = response.json['tags']
            promise.resolve(config)
          end.fail do
            config.tags = example_tags
            promise.resolve(config)
          end
        end
      end

      private

      def get(url)
        Promise.new.tap do |promise|
          cache_breaker = Time.now.to_i
          url_with_cache_breaker = [url, cache_breaker].join('?')

          HTTP.get(url_with_cache_breaker) do |response|
            if 200 == response.status_code
              promise.resolve(response)
            else
              promise.reject(response)
            end
          end
        end
      end

      def example_tags
        %w[Downtown Shopping]
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
    end
  end

  class MarkdownView
    def initialize(element, heading_element)
      @element = element
      @heading_element = heading_element
    end

    def render(markdown, heading_html)
      html = MarkdownRenderer.new(markdown).to_html

      @element.html = html
      @element.find('a').attr('target', '_blank')
      @heading_element.html = heading_html
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

      @element.find('a').on(:click) do |event|
        toggle_selector(event)
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

    def toggle_selector(event)
      target = event.target.closest('a')
      show_selector = target.attr('data-show-selector')
      hide_selector = target.attr('data-hide-selector')

      @element.find('a').remove_class('active')
      target.add_class('active')

      Element[show_selector].remove_class('hidden')
      Element[hide_selector].add_class('hidden')
    end
  end

  class BackButtonMediator
    def initialize(element, navigation_view, markdown_view)
      @element = element
      @navigation_view = navigation_view
      @markdown_view = markdown_view
    end

    def render
      @element.on(:click) do |event|
        event.prevent_default
        hide
      end
    end

    def show
      @markdown_view.show
      @element.remove_class('hidden-xs')
      @navigation_view.hide
    end

    def hide
      @element.add_class('hidden-xs')
      @markdown_view.hide
      @navigation_view.show
    end
  end
end

Document.ready? do
  Markdo::Client.new.run
end
