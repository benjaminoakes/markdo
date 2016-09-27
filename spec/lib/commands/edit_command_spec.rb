require 'spec_helper'
require 'stringio'
require 'markdo/commands/inbox_command'

module Markdo
  describe EditCommand do
    it 'edits the Markdo root in your preferred editor' do
      skip 'Shellwords not supported' unless defined?(Shellwords)

      out, err = build_command_support
      env = { 'EDITOR' => 'aneditor', 'MARKDO_ROOT' => 'spec/fixtures/' }

      expect(Kernel).to receive(:system).with('aneditor spec/fixtures/')

      EditCommand.new(out, err, env).run
    end

    it 'does not allow unsafe values for MARKDO_ROOT' do
      skip 'Shellwords not supported' unless defined?(Shellwords)

      out, err = build_command_support
      env = { 'EDITOR' => 'aneditor', 'MARKDO_ROOT' => '`ruin everything`' }

      expect(Kernel).to receive(:system).with('aneditor \`ruin\ everything\`')

      EditCommand.new(out, err, env).run
    end
  end
end
