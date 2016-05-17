require 'test_helper'
require 'markdo/ics_command'

module Markdo
  describe IcsCommand do
    it 'outputs an iCalendar feed from the input Markdown, skipping invalid dates' do
      out = StringIO.new
      err = StringIO.new
      env = { 'MARKDO_ROOT' => 'test/fixtures' }

      IcsCommand.new(out, err, env).run

      out.string.must_equal <<-ICS
BEGIN:VCALENDAR
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-CALNAME:Markdo Due Dates
BEGIN:VEVENT
DTSTART;VALUE=DATE:20140401
DTEND;VALUE=DATE:20140401
SUMMARY:Task with long-past due date
END:VEVENT
BEGIN:VEVENT
DTSTART;VALUE=DATE:20160401
DTEND;VALUE=DATE:20160401
SUMMARY:Task with due date
END:VEVENT
BEGIN:VEVENT
DTSTART;VALUE=DATE:20160401
DTEND;VALUE=DATE:20160401
SUMMARY:Task with tag-style due date
END:VEVENT
END:VCALENDAR
      ICS
    end
  end
end
