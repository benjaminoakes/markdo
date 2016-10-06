require 'spec_helper'
require 'markdo/commands/star_command'

module Markdo
  describe StarCommand do
    it 'outputs tasks with the @star tag' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_for_date_commands

      StarCommand.new(command_support).run

      expect(command_support.stdout.string).to eq(<<-EOF)
- [ ] @star Starred in inbox
- [ ] @star Starred
      EOF
    end
  end
end
