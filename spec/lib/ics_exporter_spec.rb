require 'spec_helper'
require 'markdo/models/task_collection'
require 'markdo/ics_exporter'

module Markdo
  describe IcsExporter do
    it 'produces the body of an iCalendar (.ics) file for incomplete tasks with a valid due date' do
      task_collection = TaskCollection.new([
        '- [ ] Task with no tags',
        '- [ ] @due(2016-04-01) Task with tag-style due date',
        '- [ ] @due(2016-06-31) Task with invalid date',
        '- [x] @due(2016-04-01) Completed task with tag-style due date',
      ])
      ics_exporter = IcsExporter.new(task_collection)

      begin
        Date.parse('2016-06-31')
      rescue
        # MRI raises an error, Opal pushes the date to the next valid one.
        invalid_dates_raise_error = true
      end

      if invalid_dates_raise_error
        expect(ics_exporter.to_ics).to eq(<<-ICS)
BEGIN:VCALENDAR
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-CALNAME:Markdo Due Dates
BEGIN:VEVENT
DTSTART;VALUE=DATE:20160401
DTEND;VALUE=DATE:20160401
SUMMARY:Task with tag-style due date
END:VEVENT
END:VCALENDAR
ICS
      else
        expect(ics_exporter.to_ics).to eq(<<-ICS)
BEGIN:VCALENDAR
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-CALNAME:Markdo Due Dates
BEGIN:VEVENT
DTSTART;VALUE=DATE:20160401
DTEND;VALUE=DATE:20160401
SUMMARY:Task with tag-style due date
END:VEVENT
BEGIN:VEVENT
DTSTART;VALUE=DATE:20160701
DTEND;VALUE=DATE:20160701
SUMMARY:Task with invalid date
END:VEVENT
END:VCALENDAR
ICS
      end
    end
  end
end
