require 'test_helper'
require 'markdo/task_attribute'

module Markdo
  describe TaskAttribute do
    describe 'given no value' do
      describe '#value' do
        it 'is nil' do
          TaskAttribute.new('foo', nil).value.must_be_nil
        end
      end

      describe '#date_value' do
        it 'is nil' do
          TaskAttribute.new('foo', nil).date_value.must_be_nil
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
          TaskAttribute.new('foo', 'bar').value.must_equal('bar')
        end
      end

      describe '#date_value' do
        it 'is nil' do
          TaskAttribute.new('foo', 'bar').date_value.must_be_nil
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
          TaskAttribute.new('due', '2016-01-01').value.must_equal('2016-01-01')
        end
      end

      describe '#date_value' do
        it 'is the date' do
          TaskAttribute.new('due', '2016-01-01').date_value.
            must_equal(Date.new(2016, 1, 1))
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
      attribute_1.must_equal(attribute_1)

      attribute_1.must_equal(attribute_2)
      attribute_2.must_equal(attribute_1)

      attribute_2.must_equal(attribute_2)
    end

    def assert_inequality(attribute_1, attribute_2)
      attribute_1.wont_equal(attribute_2)
      attribute_2.wont_equal(attribute_1)
    end
  end
end
