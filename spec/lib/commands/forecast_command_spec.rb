require 'spec_helper'
require 'markdo/commands/forecast_command'

module Markdo
  describe ForecastCommand do
    it 'outputs forecast counts' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      command_support = build_command_support_for_date_commands

      ForecastCommand.new(command_support).run

      expect(command_support.stdout.string).to eq(<<-XML)
Tu: 0
We: 0
Th: 0
Fr: 0
Sa: 0
Su: 2
Next: 4
      XML
    end
  end
end
