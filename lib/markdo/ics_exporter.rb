require 'date'

module Markdo
  class IcsExporter
    def initialize(task_collection)
      @task_collection = task_collection
    end

    def to_ics
      buf = []

      buf << 'BEGIN:VCALENDAR'
      buf << 'VERSION:2.0'
      buf << 'CALSCALE:GREGORIAN'
      buf << 'METHOD:PUBLISH'
      buf << 'X-WR-CALNAME:Markdo Due Dates'
      buf << events.map { |event| event.to_ics }
      buf << 'END:VCALENDAR'

      buf.
        flatten.
        map { |line| "#{line}\n" }.
        join
    end

    private

    def events
      @task_collection.
        with_attribute('due').
        reject { |task| task.complete? }.
        map { |task|
          due_date = task.attributes['due'].date_value
          summary = clean(task.body)

          if due_date
            Event.new(due_date, due_date, summary)
          end
        }.
        compact
    end

    def clean(line)
      line.sub(%r(@due\(.*\)\s), '')
    end

    class Event
      def initialize(date_start, date_end, summary)
        @date_start = date_start
        @date_end = date_end
        @summary = summary
      end

      def to_ics
        buf = []
        buf << 'BEGIN:VEVENT'
        buf << "DTSTART;VALUE=DATE:#{@date_start.strftime('%Y%m%d')}"
        buf << "DTEND;VALUE=DATE:#{@date_end.strftime('%Y%m%d')}"
        buf << "SUMMARY:#{@summary}"
        buf << 'END:VEVENT'
        buf.join("\n")
      end
    end
  end
end
