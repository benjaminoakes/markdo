module Markdo
  class FilterWidget
    def initialize(element, tasks, back_button_mediator)
      @element = element
      @tasks = tasks
      @back_button_mediator = back_button_mediator
    end

    def append_to(container_element)
      @element = container_element.append(@element).children.last
      render
    end

    def render
      @element.find('.badge').html = @tasks.count

      @element.find('a').on(:click) do |event|
        @back_button_mediator.show(event.current_target, @tasks)
      end
    end
  end
end
