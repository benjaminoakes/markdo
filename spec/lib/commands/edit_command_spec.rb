require 'spec_helper'
require 'markdo/commands/inbox_command'

module Markdo
  describe EditCommand do
    it 'edits the Markdo root in your preferred editor' do
      skip 'Shellwords not supported' unless defined?(Shellwords)

      command_support = build_command_support_object({
        'EDITOR' => 'aneditor',
        'MARKDO_ROOT' => 'spec/fixtures/'
      })

      expect(Kernel).to receive(:system).with('aneditor spec/fixtures/')

      EditCommand.new(command_support).run
    end

    it 'does not allow unsafe values for MARKDO_ROOT' do
      skip 'Shellwords not supported' unless defined?(Shellwords)

      command_support = build_command_support_object({
        'EDITOR' => 'aneditor',
        'MARKDO_ROOT' => '`ruin everything`'
      })

      expect(Kernel).to receive(:system).with('aneditor \`ruin\ everything\`')

      EditCommand.new(command_support).run
    end
  end
end
