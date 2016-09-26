require 'spec_helper'
require 'markdo/task'

module Markdo
  describe Task do
    describe 'given no tags' do
      describe '#tags' do
        it 'is empty' do
          task = build_task_no_attributes
          expect(task.tags).to eq([])
        end
      end

      describe '#attributes' do
        it 'is empty' do
          task = build_task_no_attributes
          expect(task.attributes).to eq({})
        end
      end

      def build_task_no_attributes
        Task.new('- [ ] A task')
      end
    end

    describe 'given tags' do
      describe '#tags' do
        it 'is an array of tags in the order they appear, without arguments' do
          task = Task.new('- [ ] A task @downtown @star @due(2016-01-01)')
          expect(task.tags).to eq(%w(downtown star due))
        end
      end

      describe '#attributes' do
        it 'is a hash of attributes including arguments' do
          task = Task.new('- [ ] A task @downtown @star @due(2016-01-01)')
          expect(task.attributes).to eq({
            'downtown' => TaskAttribute.new('downtown', nil),
            'star' => TaskAttribute.new('star', nil),
            'due' => TaskAttribute.new('due', '2016-01-01'),
          })
        end
      end
    end
  end
end
