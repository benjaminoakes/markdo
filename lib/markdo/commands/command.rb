require 'markdo/data_source'
require 'markdo/models/task_collection'

module Markdo
  class Command
    def initialize(stdout, stderr, env, reference_date = Date.today)
      @stdout = stdout
      @stderr = stderr
      @env = env
      @reference_date = reference_date
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
