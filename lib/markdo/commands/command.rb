require 'markdo/command_support'
require 'markdo/data_source'
require 'markdo/models/task_collection'

module Markdo
  class Command
    def initialize(command_support)
      @stdout = command_support.stdout
      @stderr = command_support.stderr
      @env = command_support.env
      @reference_date = command_support.today
    end

    def run
    end

    protected

    def data_source
      DataSource.new(@env)
    end

    def task_collection
      TaskCollection.new(data_source.lines_from_all, @reference_date)
    end

    def inbox_task_collection
      TaskCollection.new(data_source.lines_from_inbox, @reference_date)
    end
  end
end
