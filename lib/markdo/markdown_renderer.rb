if RUBY_ENGINE == 'opal'
  require 'showdown'
else
  require 'redcarpet'
end

module Markdo
  class MarkdownRenderer
    def initialize(markdown)
      @markdown = markdown
    end

    def to_html
      markdown_with_checkboxes = @markdown.
        split("\n").
        map { |line| render_task_list(line) }.
        join("\n")
      
      render(markdown_with_checkboxes)
    end

    private
    
    def render(markdown_with_checkboxes)
      if RUBY_ENGINE == 'opal'
        `return (new showdown.Converter({ noHeaderId: true })).makeHtml(markdown_with_checkboxes);`
      else
        renderer = Redcarpet::Render::HTML.new
        markdown = Redcarpet::Markdown.new(renderer)
        markdown.render(markdown_with_checkboxes)
      end
    end

    def render_task_list(line)
      if line.match(/^\s*- \[ \] /)
        inner = line.sub(/^\s*- \[ \] /, '')
        "<input disabled type=checkbox> #{inner}<br>"
      elsif line.match(/^\s*- \[x\] /)
        inner = line.sub(/^\s*- \[x\] /, '')
        "<input checked disabled type=checkbox> #{inner}<br>"
      else
        line
      end
    end
  end
end
