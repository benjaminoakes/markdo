require 'opal'
require 'jquery'
require 'opal-jquery'
require 'bootstrap'
require 'markdo/browser/tasks_controller'

module Markdo
  class Client
    def run
      controller = TasksController.new
      controller.index
    end
  end
end

Document.ready? do
  Markdo::Client.new.run
end
