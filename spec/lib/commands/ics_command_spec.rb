require 'spec_helper'
require 'markdo/commands/ics_command'

module Markdo
  describe IcsCommand do
    it 'outputs an iCalendar feed from the input Markdown, skipping invalid dates' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)
      
      command_support = build_command_support_object({
        'MARKDO_ROOT' => 'spec/fixtures/ics_command'
      })

      IcsCommand.new(command_support).run

      expect(command_support.stdout.string).to eq(<<-ICS)
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
    end
  end
end
