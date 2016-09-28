require 'spec_helper'
require 'markdo/commands/star_command'

module Markdo
  describe QueryCommand do
    it 'outputs tasks that match the given string, case insensitive' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, err = build_command_support
      env = { 'MARKDO_ROOT' => 'spec/fixtures/query_command' }

      QueryCommand.new(out, err, env).run('asdf')

      expect(out.string).to eq(<<-EOF)
- [ ] ASDF in inbox
- [ ] asdf in inbox
- [ ] ASDF
- [ ] asdf
      EOF
    end
  end
end
