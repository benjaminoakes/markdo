module Markdo
  class DataSource
    def initialize(env)
      @env = env
    end

    def all_lines
      Dir.
        glob(markdown_glob).
        map { |path| File.readlines(path, encoding: 'UTF-8') }.
        flatten
    end

    private

    def markdown_glob
      "#{@env['MARKDO_ROOT']}/*.md"
    end
  end
end