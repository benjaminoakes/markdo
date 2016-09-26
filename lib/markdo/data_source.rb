module Markdo
  class DataSource
    def initialize(env)
      @env = env
    end

    def all_lines
      Dir.
        glob("#{@env['MARKDO_ROOT']}/*.md").
        map { |path| File.readlines(path, encoding: 'UTF-8') }.
        flatten
    end

    def from_file(filename)
      path = "#{@env['MARKDO_ROOT']}/#{filename}"
      File.readlines(path, encoding: 'UTF-8')
    end
  end
end
