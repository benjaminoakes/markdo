require 'spec_helper'
require 'markdo/commands/tag_command'

module Markdo
  describe TagCommand do
    it 'outputs tasks with the given tag' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, err = build_command_support
      env = { 'MARKDO_ROOT' => 'spec/fixtures/tag_command' }

      TagCommand.new(out, err, env).run('foo')

      expect(out.string).to eq(<<-EOF)
- [ ] Tagged @foo in inbox
- [ ] Tagged @foo
      EOF
    end
  end
end
