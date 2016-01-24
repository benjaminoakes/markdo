#encoding: utf-8
require 'markdo/command'

module Markdo
  class QueryCommand < Command
    def run(string)
      regexp = Regexp.new(string, Regexp::IGNORECASE)

      matches = Dir.
        glob(markdown_glob).
        map { |path| File.readlines(path) }.
        flatten.
        grep(regexp)

      @stdout.puts(matches)
    end

    protected

    def markdown_glob
      "#{@env['MARKDO_ROOT']}/*.md"
    end
  end
end
