module Markdo
  class HelpCommand
    def initialize(stdout, stderr)
      @stdout = stdout
      @stderr = stderr
    end

    def run
      @stderr.puts <<-EOF
Markdown-based task manager.

    help, --help          Display this help text.
    version, --version    Display the version.
EOF

      exit 1
    end
  end
end
