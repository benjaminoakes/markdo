module Markdo
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
end
