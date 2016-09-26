require 'spec_helper'
require 'markdo/task_attribute'

module Markdo
  describe TaskAttribute do
    describe 'given no value' do
      describe '#value' do
        it 'is nil' do
          expect(TaskAttribute.new('foo', nil).value).to be_nil
        end
      end

      describe '#date_value' do
        it 'is nil' do
          expect(TaskAttribute.new('foo', nil).date_value).to be_nil
        end
      end

      describe '#==' do
        it 'is true when key and value are the same' do
          assert_equality(TaskAttribute.new('foo', nil),
                          TaskAttribute.new('foo', nil))
        end

        it 'is false when key is different' do
          assert_inequality(TaskAttribute.new('foo', nil),
                            TaskAttribute.new('bar', nil))
        end
      end
    end

    describe 'given a word value' do
      describe '#value' do
        it 'is that word' do
          expect(TaskAttribute.new('foo', 'bar').value).to eq('bar')
        end
      end

      describe '#date_value' do
        it 'is nil' do
          expect(TaskAttribute.new('foo', 'bar').date_value).to be_nil
        end
      end

      describe '#==' do
        it 'is true when key and value are the same' do
          assert_equality(TaskAttribute.new('foo', 'bar'),
                          TaskAttribute.new('foo', 'bar'))
        end

        it 'is false when key is different' do
          assert_inequality(TaskAttribute.new('foo', 'bar'),
                            TaskAttribute.new('bar', 'bar'))
        end
      end
    end

    describe 'given an ISO-8601-formatted date value' do
      describe '#value' do
        it 'is the string' do
          expect(TaskAttribute.new('due', '2016-01-01').value).to eq('2016-01-01')
        end
      end

      describe '#date_value' do
        it 'is the date' do
          expect(TaskAttribute.new('due', '2016-01-01').date_value).
            to eq(Date.new(2016, 1, 1))
        end
      end

      describe '#==' do
        it 'is true when key and value are the same' do
          assert_equality(TaskAttribute.new('foo', '2016-01-01'),
                          TaskAttribute.new('foo', '2016-01-01'))
        end

        it 'is false when key is different' do
          assert_inequality(TaskAttribute.new('foo', '2016-01-01'),
                            TaskAttribute.new('bar', '2016-01-01'))
        end
      end
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
end
