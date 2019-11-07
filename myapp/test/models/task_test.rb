require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "should not save task without name" do
    task = Task.new
    assert_not task.save
  end

  test "should not save task with name length exceed 50" do
    task = Task.new
    task.name = "0123456789
                 0123456789
                 0123456789
                 0123456789
                 0123456789
                 0123456789"
    assert_not task.save
  end
end
