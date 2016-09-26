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

    def task_collection
      lines = DataSource.new(@env).all_lines
      TaskCollection.new(lines, @reference_date)
    end

    def inbox_task_collection
      lines = DataSource.new(@env).from_file(@env['MARKDO_INBOX'])
      TaskCollection.new(lines, @reference_date)
    end
  end
end
