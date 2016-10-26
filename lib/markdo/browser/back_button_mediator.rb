module Markdo
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
