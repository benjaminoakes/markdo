module Markdo
  class TaskAttribute
    attr_reader :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end

    def date_value
      Date.parse(value.to_s)
    rescue ArgumentError
      nil
    end

    def ==(other)
      other.key == key && other.value == value
    end
  end
end
