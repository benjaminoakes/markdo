module Markdo
  class CommandSupport
    attr_reader :stdin, :stdout, :stderr, :env, :today
    attr_writer :stdin
    
    def initialize(stdin: STDIN, stdout: STDOUT, stderr: STDERR, env: ENV, today: Date.today)
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @env = env
      @today = today
    end
  end
end
