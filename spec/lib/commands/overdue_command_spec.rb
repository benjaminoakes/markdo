require 'spec_helper'
require 'markdo/commands/overdue_command'

module Markdo
  describe OverdueCommand do
    it 'outputs overdue tasks' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, *rest = build_date_commands_support

      OverdueCommand.new(out, *rest).run

      expect(out.string).to eq(<<-EOF)
- [ ] @due(2016-01-01) Overdue
- [ ] @due(2016-01-01) Overdue in inbox
      EOF
    end
  end
end
