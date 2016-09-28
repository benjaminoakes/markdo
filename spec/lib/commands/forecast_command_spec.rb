require 'spec_helper'
require 'markdo/commands/forecast_command'

module Markdo
  describe ForecastCommand do
    it 'outputs forecast counts' do
      skip 'Dir.glob not supported' unless Dir.respond_to?(:glob)

      out, *rest = build_date_commands_support

      ForecastCommand.new(out, *rest).run

      expect(out.string).to eq(<<-XML)
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
