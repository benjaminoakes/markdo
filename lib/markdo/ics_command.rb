require 'markdo/command'
require 'date'
require 'uri'

module Markdo
  class IcsCommand < Command
    def run
      events = Dir.
        glob(markdown_glob).
        map { |path| File.readlines(path, encoding: 'UTF-8') }.
        flatten.
        grep(%r(\b\d{4}-\d{2}-\d{2}\b)).
        map { |line|
          begin
            raw_due_date = line.match(%r(\b\d{4}-\d{2}-\d{2}\b))
            due_date = Date.parse(raw_due_date[0])
            Event.new(due_date, due_date, clean(line))
          rescue ArgumentError
            # invalid date, skip it
          end
        }.compact

      ics = template(events)

      @stdout.puts(ics)
    end

    protected

    Event = Struct.new(:date_start, :date_end, :summary) do
      def to_ics
        buf = []
        buf << 'BEGIN:VEVENT'
        buf << "DTSTART;VALUE=DATE:#{date_start.strftime('%Y%m%d')}"
        buf << "DTEND;VALUE=DATE:#{date_end.strftime('%Y%m%d')}"
        buf << "SUMMARY:#{summary}"
        buf << 'END:VEVENT'
        buf.join("\n")
      end
    end

    def markdown_glob
      "#{@env['MARKDO_ROOT']}/*.md"
    end

    def clean(line)
      line.
        sub(/\s*[-*] \[.\]\s+/, '').
        sub(%r(\b\d{4}-\d{2}-\d{2}\b), '').
        strip
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
