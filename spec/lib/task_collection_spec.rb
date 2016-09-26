require 'spec_helper'
require 'markdo/task_collection'

module Markdo
  describe TaskCollection do
    describe '#with_tag' do
      it 'returns tasks with the given tag' do
        expect(build_task_collection.with_tag('tag')).to eq([
          Task.new('- [ ] Example @tag'),
        ])
      end
    end

    describe '#with_attribute' do
      it 'returns tasks with the given tag, with or without a value' do
        expect(build_task_collection.with_attribute('priority')).to eq([
          Task.new('- [ ] Example @priority'),
          Task.new('- [ ] Example @priority(1)'),
          Task.new('- [ ] Example @priority(2)'),
        ])
      end
    end

    describe '#overdue' do
      it 'returns tasks due before the reference date' do
        expect(build_task_collection.overdue).to eq([
          Task.new('- [ ] Example @due(2016-02-27)'),
        ])
      end
    end

    describe '#due_today' do
      it 'returns tasks due on the reference date' do
        expect(build_task_collection.due_today).to eq([
          Task.new('- [ ] Example @due(2016-02-28)'),
        ])
      end
    end

    describe '#due_tomorrow' do
      it 'returns tasks due the day after the reference date' do
        expect(build_task_collection.due_tomorrow).to eq([
          Task.new('- [ ] Example @due(2016-02-29)'),
        ])
      end
    end

    describe '#due_soon' do
      it 'returns tasks due within a week of the day after the reference date' do
        expect(build_task_collection.due_soon).to eq([
          Task.new('- [ ] Example @due(2016-03-01)'),
          Task.new('- [ ] Example @due(2016-03-02)'),
          Task.new('- [ ] Example @due(2016-03-03)'),
          Task.new('- [ ] Example @due(2016-03-04)'),
          Task.new('- [ ] Example @due(2016-03-05)'),
          Task.new('- [ ] Example @due(2016-03-06)'),
        ])
      end
    end

    describe '#deferred_until_today' do
      it 'returns tasks deferred up until and including the reference date' do
        expect(build_task_collection.deferred_until_today).to eq([
          Task.new('- [ ] Example @defer(1996-01-01)'),
          Task.new('- [ ] Example @defer(2016-02-27)'),
          Task.new('- [ ] Example @defer(2016-02-28)'),
        ])
      end
    end

    def build_task_collection
      reference_date = Date.new(2016, 2, 28)

      lines = [
        '- [ ] No tags',
        '- [ ] Example @tag',
        '- [ ] Example @priority',
        '- [ ] Example @priority(1)',
        '- [ ] Example @priority(2)',
        '- [ ] Example @due(2016-02-27)',
        '- [ ] Example @due(2016-02-28)',
        '- [ ] Example @due(2016-02-29)',
        '- [ ] Example @due(2016-03-01)',
        '- [ ] Example @due(2016-03-02)',
        '- [ ] Example @due(2016-03-03)',
        '- [ ] Example @due(2016-03-04)',
        '- [ ] Example @due(2016-03-05)',
        '- [ ] Example @due(2016-03-06)',
        '- [ ] Example @due(2016-03-07)',
        '- [ ] Example @defer(1996-01-01)',
        '- [ ] Example @defer(2016-02-27)',
        '- [ ] Example @defer(2016-02-28)',
        '- [ ] Example @defer(2016-02-29)',
      ]

      TaskCollection.new(lines, reference_date)
    end
  end
end
