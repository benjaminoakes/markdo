require 'spec_helper'
require 'markdo/task'

module Markdo
  describe Task do
    describe '#==' do
      it 'is equal if the line is equal' do
        assert_equality(Task.new('- [ ] Foo'),
                        Task.new('- [ ] Foo'))
      end

      it 'is inequal if the line is equal' do
        assert_inequality(Task.new('- [ ] Foo'),
                          Task.new('- [ ] Bar'))
      end

      def assert_equality(attribute_1, attribute_2)
        expect(attribute_1).to eq(attribute_1)

        expect(attribute_1).to eq(attribute_2)
        expect(attribute_2).to eq(attribute_1)

        expect(attribute_2).to eq(attribute_2)
      end

      def assert_inequality(attribute_1, attribute_2)
        expect(attribute_1).not_to eq(attribute_2)
        expect(attribute_2).not_to eq(attribute_1)
      end
    end

    describe 'given no tags' do
      describe '#tags' do
        it 'is empty' do
          expect(Task.new('- [ ] A task').tags).to eq([])
        end
      end

      describe '#attributes' do
        it 'is empty' do
          expect(Task.new('- [ ] A task').attributes).to eq({})
        end
      end
    end

    describe 'given tags' do
      describe '#tags' do
        it 'is an array of lowercase tags in the order they appear, without arguments' do
          task = Task.new('- [ ] A task @downtown @star @due(2016-01-01) @ALLCAPS')
          expect(task.tags).to eq(%w(downtown star due allcaps))
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
