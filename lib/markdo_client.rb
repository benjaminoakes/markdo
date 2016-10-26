require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/models/config'
require 'markdo/models/task_collection'
require 'markdo/browser/browser_template'
require 'markdo/browser/filter_widget'
require 'markdo/browser/markdown_view'

module Markdo
  class Client
    def run
      controller = TasksController.new
      controller.index
    end
  end

  class TasksController
    def index
      view = TasksView.new

      Promise.when(Config.fetch, TaskCollection.fetch).then do |config, task_collection|
        view.render(config, task_collection)
      end
    end
  end

  class TasksView
    def initialize
      @markdown_view = MarkdownView.new(Element['#rb-markdown-document'], Element['#rb-document-heading'])
      @navigation_view = NavigationView.new(Element['#rb-nav'])
      @back_button_mediator = BackButtonMediator.new(Element['#rb-back-button'], @navigation_view, @markdown_view)
    end

    def render(config, task_collection)
      @back_button_mediator.render
      render_tag_filters(task_collection, config)
      render_static_filters(task_collection)
    end

    private

    def render_tag_filters(task_collection, config)
      filter_template = BrowserTemplate.new(Element['#rb-filter-template'])
      container_element = Element['#rb-tag-nav ul']

      config.tags.each do |tag|
        new_filter_widget = FilterWidget.new(
          filter_template.render(label: tag),
          task_collection.with_tag(tag),
          @back_button_mediator
        )

        new_filter_widget.append_to(container_element)
      end
    end

    def render_static_filters(task_collection)
      Element['.rb-filter-widget'].each do |element|
        tag = element.attr('data-task-collection-with-tag')
        scope = element.attr('data-task-collection-scope')

        tasks = tag ? task_collection.with_tag(tag) : task_collection.send(scope)

        FilterWidget.new(element, tasks, @back_button_mediator).render
      end
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
