require 'markdo/query_command'

module Markdo
  class TagCommand < QueryCommand
    def run(string)
      super("@#{string}")
    end
  end
end
