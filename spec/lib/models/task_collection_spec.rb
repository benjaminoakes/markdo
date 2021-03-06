require 'spec_helper'
require 'markdo/models/task_collection'

module Markdo
  describe TaskCollection do
    describe '#all' do
      it 'returns all tasks' do
        task_collection = TaskCollection.new([
          '- [ ] Example 1',
          '- [ ] Example 2',
        ])

        expect(task_collection.all).to eq([
          Task.new('- [ ] Example 1'),
          Task.new('- [ ] Example 2'),
        ])
      end
    end

    describe '#complete' do
      it 'returns checked tasks' do
        task_collection = TaskCollection.new([
          '- [x] Example 1',
          '- [ ] Example 2',
        ])

        expect(task_collection.complete).to eq([
          Task.new('- [x] Example 1'),
        ])
      end
    end

    describe '#with_match' do
      it 'returns tasks matching a regular expression' do
        task_collection = TaskCollection.new([
          '- [ ] Foo',
          '- [ ] Bar',
        ])

        expect(task_collection.with_match(/foo/i)).to eq([
          Task.new('- [ ] Foo'),
        ])
      end

      it 'returns tasks matching a string' do
        task_collection = TaskCollection.new([
          '- [ ] Foo',
          '- [ ] Bar',
        ])

        expect(task_collection.with_match(/Bar/)).to eq([
          Task.new('- [ ] Bar'),
        ])
      end
    end

    describe '#with_tag' do
      it 'returns tasks with the given tag' do
        expect(build_task_collection.with_tag('tag')).to eq([
          Task.new('- [ ] Example @tag'),
        ])
      end
    end

    describe '#starred' do
      it 'returns tasks with the @star tag' do
        expect(build_task_collection.starred).to eq([
          Task.new('- [ ] Example @star'),
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

    describe '#due_on' do
      it 'returns tasks due on the given date' do
        expect(build_task_collection.due_on(Date.new(2016, 3, 3))).to eq([
          Task.new('- [ ] Example @due(2016-03-03)'),
        ])
      end
    end

    describe '#due_between' do
      it 'returns tasks due between the given begin date and end date' do
        begin_date = Date.new(2016, 3, 3)
        end_date = Date.new(2016, 3, 5)
        tasks = build_task_collection.due_between(begin_date, end_date)

        expect(tasks).to eq([
          Task.new('- [ ] Example @due(2016-03-03)'),
          Task.new('- [ ] Example @due(2016-03-04)'),
          Task.new('- [ ] Example @due(2016-03-05)'),
        ])
      end
    end

    describe '#overdue' do
      it 'returns tasks due before today' do
        expect(build_task_collection.overdue).to eq([
          Task.new('- [ ] Example @due(2016-02-27)'),
        ])
      end
    end

    describe '#due_today' do
      it 'returns tasks due today' do
        expect(build_task_collection.due_today).to eq([
          Task.new('- [ ] Example @due(2016-02-28)'),
        ])
      end
    end

    describe '#due_tomorrow' do
      it 'returns tasks due the day after today' do
        expect(build_task_collection.due_tomorrow).to eq([
          Task.new('- [ ] Example @due(2016-02-29)'),
        ])
      end
    end

    describe '#due_soon' do
      it 'returns tasks due within a week of the day after today' do
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
      it 'returns tasks deferred up until and including today' do
        expect(build_task_collection.deferred_until_today).to eq([
          Task.new('- [ ] Example @defer(1996-01-01)'),
          Task.new('- [ ] Example @defer(2016-02-27)'),
          Task.new('- [ ] Example @defer(2016-02-28)'),
        ])
      end
    end

    def build_task_collection
      today = Date.new(2016, 2, 28)

      lines = [
        '- [ ] No tags',
        '- [ ] Example @tag',
        '- [ ] Example @star',
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

      TaskCollection.new(lines, today)
    end
  end
end
