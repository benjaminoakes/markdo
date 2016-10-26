require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/browser/tasks_view'
require 'markdo/models/config'
require 'markdo/models/task_collection'

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
end

Document.ready? do
  Markdo::Client.new.run
end
