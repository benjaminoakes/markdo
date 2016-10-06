require 'spec_helper'
require 'markdo/commands/star_command'

module Markdo
  describe QueryCommand do
    it 'outputs tasks that match the given string, case insensitive' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_object({
        'MARKDO_ROOT' => 'spec/fixtures/query_command'
      })

      QueryCommand.new(command_support).run('asdf')

      expect(command_support.stdout.string).to eq(<<-EOF)
- [ ] ASDF in inbox
- [ ] asdf in inbox
- [ ] ASDF
- [ ] asdf
      EOF
    end
  end
end
