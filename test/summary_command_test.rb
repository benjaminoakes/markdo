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
Overdue: 3
      XML
    end
  end
end
