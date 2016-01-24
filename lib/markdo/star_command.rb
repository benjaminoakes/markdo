require 'markdo/tag_command'

module Markdo
  class StarCommand < TagCommand
    def run
      super('star')
    end
  end
end
