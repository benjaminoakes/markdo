require 'markdo/command'
require 'markdo/task_collection'
require 'date'
require 'uri'

module Markdo
  class IcsCommand < Command
    def run
      lines = Dir.
        glob(markdown_glob).
        map { |path| File.readlines(path, encoding: 'UTF-8') }.
        flatten

      events = TaskCollection.new(lines).
        with_attribute('due').
        reject { |task| task.complete? }.
        map { |task|
          due_date = task.attributes['due'].date_value
          Event.new(due_date, due_date, clean(task.body))
        }

      ics = template(events)

      @stdout.puts(ics)
    end

    protected

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

    def markdown_glob
      "#{@env['MARKDO_ROOT']}/*.md"
    end

    def clean(line)
      line.sub(%r(@due\(\b\d{4}-\d{2}-\d{2}\b\)\s), '')
    end

    def template(events)
      buf = []

      buf << 'BEGIN:VCALENDAR'
      buf << 'VERSION:2.0'
      buf << 'CALSCALE:GREGORIAN'
      buf << 'METHOD:PUBLISH'
      buf << 'X-WR-CALNAME:Markdo Due Dates'
      buf << events.map { |event| event.to_ics }
      buf << 'END:VCALENDAR'

      buf.flatten.join("\n")
    end
  end
end
