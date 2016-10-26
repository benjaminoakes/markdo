require 'spec_helper'
require 'markdo/pencil_mustache'

module Markdo
  describe PencilMustache do
    describe '.render' do
      it 'replaces tokens within mustaches' do
        template = 'Say something loud!  Maybe he\'ll use it in his examples!  Like what?  Like "{{adjective}} {{noun}}"?'
        doc = { :adjective => 'chunky',
                :noun => 'bacon' }

        expected = 'Say something loud!  Maybe he\'ll use it in his examples!  Like what?  Like "chunky bacon"?'
        expect(PencilMustache.render(template, doc)).to eq(expected)
      end
    end
  end
end
