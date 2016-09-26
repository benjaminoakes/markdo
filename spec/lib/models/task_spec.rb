require 'spec_helper'
require 'markdo/models/task'

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
    end

    describe '#complete?' do
      describe 'given an incomplete task' do
        it 'is false' do
          expect(Task.new('- [ ] Incomplete task').complete?).to eq(false)
        end
      end

      describe 'given a complete task' do
        it 'is true' do
          expect(Task.new('- [x] Complete task').complete?).to eq(true)
        end
      end
    end

    describe '#body' do
      it 'strips the markdown checkbox' do
        expect(Task.new('- [ ] Incomplete task').body).to eq('Incomplete task')
        expect(Task.new('- [x] Complete task').body).to eq('Complete task')
      end

      it 'strips whitespace' do
        expect(Task.new(" \t - [ ] Incomplete task\n").body).to eq('Incomplete task')
        expect(Task.new(" \t - [x] Complete task\n").body).to eq('Complete task')
        expect(Task.new("- [x] Complete task \t \n").body).to eq('Complete task')
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
