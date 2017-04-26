require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:enableduser)
    @task = tasks(:two)
    @board = @user.boards.first
  end

  test 'should be valid' do
    assert @task.valid?
  end

  test 'user_id should be present' do
    @task.user_id = nil
    assert_not @task.valid?
  end

  test 'non-integer user_id should be invalid' do
    @task.user_id = 'aaa'
    assert_not @task.valid?
  end

  test 'integer user_id should be valid' do
    @task.user_id = 1
    assert @task.valid?
  end

  test 'board_id should be present' do
    @task.board_id = nil
    assert_not @task.valid?
  end

  test 'non-integer board_id should be invalid' do
    @task.board_id = 'aaa'
    assert_not @task.valid?
  end

  test 'integer board_id should be valid' do
    @task.board_id = 1
    assert @task.valid?
  end

  test 'title should be present' do
    @task.title = '     '
    assert_not @task.valid?
  end

  test 'title >100 chars should be invalid' do
    @task.title = 'a' * 101
    assert_not @task.valid?
  end

  test 'title <=100 chars should be valid' do
    @task.title = 'a' * 100
    assert @task.valid?
  end

  test 'description should be optional' do
    @task.description = nil
    assert @task.valid?
  end

  test 'description should accept strings of any length' do
    @task.description = 'a' * 256
    assert @task.valid?
  end

  test 'status should be present' do
    @task.status = nil
    assert_not @task.valid?
  end

  test 'completed? should be true for completed tasks' do
    Task.where(status: 'completed').find_all do |task|
      assert task.completed?
      assert_not task.active?
    end
  end

  test 'active? should be true for active tasks' do
    Task.where(status: 'active').find_all do |task|
      assert task.active?
      assert_not task.completed?
    end
  end

  test 'time_in_current_status should return correct values' do
    task = Task.create!(
      title: 'new task',
      user_id: @user.id,
      board_id: @board.id,
      description: 'a new task',
      status: 'active',
      created_at: 1.week.ago
    )

    (1..10).each do |n|
      task.task_statuses.last.update_attribute(:created_at, n.weeks.ago)
      assert_equal n * 5, task.time_in_current_status
    end

    assert_equal task.status, 'active'
    task.task_statuses.last.update_attribute(:created_at, 1.week.ago)
    assert_equal 5, task.time_in_current_status
  end

  test 'newest_first scope should be ordered by created_at ascending' do
    assert_equal(
      Task.all.order(created_at: :asc).to_a,
      Task.all.newest_first.to_a
    )
  end

  test 'oldest_first scope should be ordered by created_at descending' do
    assert_equal(
      Task.all.order(created_at: :desc).to_a,
      Task.all.oldest_first.to_a
    )
  end

  test 'completed scope should return completed statuses only' do
    Task.completed.find_each { |task| assert_equal 'completed', task.status }
  end

  test 'incomplete scope should return incomplete statuses only' do
    Task.incomplete.find_each do |task|
      assert_not_equal 'completed', task.status
    end
  end

  test 'created_this_week scope should return tasks created this week only' do
    Task.created_this_week.find_each do |task|
      assert task.created_at >= Time.zone.now.beginning_of_week \
             && task.created_at <= Time.zone.now.end_of_week
    end
  end

  test 'completed_this_week should return tasks completed this week only' do
    Task.completed_this_week.find_each do |task|
      assert task.completed_at >= Time.zone.now.beginning_of_week \
             && task.completed_at <= Time.zone.now.end_of_week
    end
  end

  test 'not_owned_by(user) should return tasks not owned by the passed user' do
    Task.not_owned_by(@user).find_each do |task|
      assert_not_equal @user, task.user
    end
  end

  test 'owned_by(user) should return tasks owned by the passed user only' do
    Task.owned_by(@user).find_each { |task| assert_equal @user, task.user }
  end
end
