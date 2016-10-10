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
      Element['#rb-due-today-count'].html = task_collection.due_today.count
      Element['#rb-starred-count'].html = task_collection.starred.count
      Element['#rb-due-tomorrow-count'].html = task_collection.due_tomorrow.count
    end

    private

    def fetch_lines
      [
        '- [ ] Example @star'
      ]
    end
  end
end

Document.ready? do
  Markdo::Client.new.run
end
