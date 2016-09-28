require 'spec_helper'
require 'markdo/commands/tomorrow_command'

module Markdo
  describe TomorrowCommand do
    it 'outputs tasks due tomorrow' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, *rest = build_date_commands_support

      TomorrowCommand.new(out, *rest).run

      expect(out.string).to eq(<<-EOF)
- [ ] @due(2016-02-29) Due tomorrow in inbox
- [ ] @due(2016-02-29) Due tomorrow
      EOF
    end
  end
end
