require 'markdo/pencil_mustache'

module Markdo
  class BrowserTemplate
    def initialize(element)
      @element = element
    end

    def render(locals)
      PencilMustache.render(raw_template, locals)
    end

    private

    def raw_template
      @raw_template ||= @element.html
    end
  end
end
