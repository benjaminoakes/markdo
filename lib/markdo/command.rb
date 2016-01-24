module Markdo
  class Command
    def initialize(stdout, stderr, env)
      @stdout = stdout
      @stderr = stderr
      @env = env
    end

    def run
    end
  end
end
