require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/models/task_collection'

module Markdo
  class Client
    def run
      lines = fetch_lines
      task_collection = TaskCollection.new(lines)

      Element['#rb-overdue-count'].html = task_collection.due_today.count
      Element['#rb-due-today-count'].html = task_collection.due_today.count
      Element['#rb-wip-count'].html = task_collection.with_tag('wip').count
      Element['#rb-starred-count'].html = task_collection.starred.count

      Element['#rb-due-tomorrow-count'].html = task_collection.due_tomorrow.count
      Element['#rb-due-soon-count'].html = task_collection.due_soon.count
      Element['#rb-deferred-until-today-count'].html = task_collection.deferred_until_today.count
      Element['#rb-next-count'].html = task_collection.with_tag('next').count

      Element['#rb-markdown-document'].html = render_markdown
    end

    private

    def fetch_lines
      [
        '- [ ] Example @star'
      ]
    end

    def render_markdown
      '<p><input disabled="" type="checkbox"> Example @star<br></p>'
    end
  end
end

Document.ready? do
  Markdo::Client.new.run
end
