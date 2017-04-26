require 'test_helper'

class TaskStatusTest < ActiveSupport::TestCase
  def setup
    @user = users(:enableduser)
    @task_status = task_statuses(:one)
  end

  test 'should be valid' do
    assert @task_status.valid?
  end

  test 'task_id should be present' do
    @task_status.task_id = '     '
    assert_not @task_status.valid?
  end

  test 'created_at should be present' do
    @task_status.created_at = '   '
    assert_not @task_status.valid?
  end

  test 'default scope should be ordered by created_at ascending' do
    assert_equal TaskStatus.all.order(created_at: :asc), TaskStatus.all
  end

  test 'active scope should be return only active task statuses' do
    TaskStatus.active.find_each do |task_status|
      assert_equal 'active', task_status.status
    end
  end
end
