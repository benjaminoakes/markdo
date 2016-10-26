require 'markdo/markdown_renderer'

module Markdo
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
end
