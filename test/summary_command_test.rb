require 'test_helper'
require 'markdo/summary_command'

module Markdo
  describe SummaryCommand do
    it 'outputs RSS from the input Markdown' do
      out = StringIO.new
      err = StringIO.new
      env = { 'MARKDO_ROOT' => 'test/fixtures' }

      SummaryCommand.new(out, err, env).run

      out.string.must_equal <<-XML
Overdue: 2
Star: 0
Today: 0
Tomorrow: 0
      XML
    end
  end
end