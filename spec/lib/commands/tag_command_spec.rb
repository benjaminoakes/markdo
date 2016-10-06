require 'spec_helper'
require 'markdo/commands/tag_command'

module Markdo
  describe TagCommand do
    it 'outputs tasks with the given tag' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_object({
        'MARKDO_ROOT' => 'spec/fixtures/tag_command'
      })

      TagCommand.new(command_support).run('foo')

      expect(command_support.stdout.string).to eq(<<-EOF)
- [ ] Tagged @foo in inbox
- [ ] Tagged @foo
      EOF
    end
  end
end
