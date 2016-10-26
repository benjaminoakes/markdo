require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/models/config'
require 'markdo/models/task_collection'
require 'markdo/browser/back_button_mediator'
require 'markdo/browser/browser_template'
require 'markdo/browser/filter_widget'
require 'markdo/browser/markdown_view'
require 'markdo/browser/navigation_view'

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
end

Document.ready? do
  Markdo::Client.new.run
end
