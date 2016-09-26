require 'markdo/models/task_attribute'

module Markdo
  class Task
    attr_reader :line

    def initialize(line)
      @line = line
    end

    def ==(other)
      other.line == line
    end

    def complete?
      !!line.match(/\s*[-*] \[x\]\s+/)
    end

    def body
      line.
        sub(/\s*[-*] \[.\]\s+/, '').
        sub(/\s*$/, '')
    end

    def tags
      attributes.keys
    end

    def attributes
      a = line.
        scan(/\s@\S+/).
        map { |s|
          match_data = s.match(/@([a-zA-Z0-9]+)(\((.+)\))?/)

          if match_data
            key = match_data[1].downcase
            value = match_data[3]

            [key, TaskAttribute.new(key, value)]
          end
        }
      
      Hash[a]
    end
  end
end
