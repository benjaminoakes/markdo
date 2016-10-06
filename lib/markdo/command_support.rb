module Markdo
  class CommandSupport
    attr_reader :stdout, :stderr, :env, :today
    
    def initialize(stdout: STDOUT, stderr: STDERR, env: ENV, today: Date.today)
      @stdout = stdout
      @stderr = stderr
      @env = env
      @today = today
    end
  end
end
