require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/config'
require 'markdo/markdown_renderer'
require 'markdo/pencil_mustache'
require 'markdo/models/task_collection'

module Markdo
  class Client
    def initialize
      @markdown_view = MarkdownView.new(Element['#rb-markdown-document'], Element['#rb-document-heading'])
      @navigation_view = NavigationView.new(Element['#rb-nav'])
      @back_button_mediator = BackButtonMediator.new(Element['#rb-back-button'], @navigation_view, @markdown_view)
      @filter_template = Template.new('#rb-filter-template')
    end

    def run
      @back_button_mediator.render

      BrowserDataSource.fetch_lines_from_all.then do |lines|
        task_collection = TaskCollection.new(lines)

        BrowserDataSource.fetch_config.then do |config|
          config.tags.each do |tag|
            new_filter_widget = FilterWidget.new(
              nil,
              @back_button_mediator,
              task_collection.with_tag(tag),
              @filter_template,
              Element['#rb-tag-nav ul']
            )

            new_filter_widget.render(tag)
          end
        end

        Element['.rb-filter-widget'].each do |element|
          tag = element.attr('data-task-collection-with-tag')
          scope = element.attr('data-task-collection-scope')

          tasks = tag ? task_collection.with_tag(tag) : task_collection.send(scope)

          FilterWidget.new(element, @back_button_mediator, tasks).render
        end
      end
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

  class Template
    def initialize(id)
      @id = id
    end

    def render(locals)
      PencilMustache.render(raw_template, locals)
    end

    private

    def raw_template
      @raw_template ||= Element[@id].html
    end
  end

  class FilterWidget
    def initialize(element, back_button_mediator, tasks, filter_template, container_element)
      @element = element
      @back_button_mediator = back_button_mediator
      @tasks = tasks
      @filter_template = filter_template
      @container_element = container_element
    end

    def render(label)
      if @element.nil?
        @element = append_element(label)
      end

      @element.find('.badge').html = @tasks.count

      @element.find('a').on(:click) do |event|
        @back_button_mediator.show(event.current_target, @tasks)
      end
    end

    private

    def append_element(label)
      filter = @filter_template.render(label: label)
      @container_element.append(filter).children.last
    end
  end

  class MarkdownView
    def initialize(element, heading_element)
      @element = element
      @heading_element = heading_element
    end

    def render(tasks, heading_html)
      lines = tasks.map { |task| task.line }
      markdown = lines.join("\n")
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
      @navigation_view.render

      @element.on(:click) do |event|
        event.prevent_default
        hide
      end
    end

    def show(target, tasks)
      @navigation_view.activate(target)
      @markdown_view.show
      @element.remove_class('hidden-xs')
      @navigation_view.hide
      @markdown_view.render(tasks, target.html)
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
