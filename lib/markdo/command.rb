module Markdo
  class Command
    def initialize(stdout, stderr, env)
      @stdout = stdout
      @stderr = stderr
      @env = env
    end

    def run
    end

    protected

    def task_collection
      lines = DataSource.new(@env).all_lines
      TaskCollection.new(lines)
    end
  end
end
