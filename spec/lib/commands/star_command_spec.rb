require 'spec_helper'
require 'markdo/commands/star_command'

module Markdo
  describe StarCommand do
    it 'outputs tasks with the @star tag' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, *rest = build_date_commands_support

      StarCommand.new(out, *rest).run

      expect(out.string).to eq(<<-EOF)
- [ ] @star Starred
- [ ] @star Starred in inbox
      EOF
    end
  end
end
