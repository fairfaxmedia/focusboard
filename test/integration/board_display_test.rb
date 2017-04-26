require 'test_helper'

class BoardDisplayTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:enableduser)
    @board = boards(:one)
    post user_session_path, user: { email: @user.email, password: 'password' }
  end

  test 'displaying todays completed tasks' do
    # Create completed task
    title = 'todays completed task'
    description = 'a sample task'
    status = 'completed'
    completed_at = Time.zone.now
    assert_difference 'Task.count', 1 do
      post board_tasks_path(@board), task: {
        title: title,
        description: description,
        status: status,
        user_id: @user.id,
        completed_at: completed_at,
        board_id: @board.id
      }
    end
    get board_path(@board)
    assert_match title, response.body
  end

  test 'not displaying yesterdays completed tasks' do
    # Create completed task
    title = 'yesterdays completed task'
    description = 'a sample task'
    status = 'completed'
    completed_at = 2.days.ago
    assert_difference 'Task.count', 1 do
      post board_tasks_path(@board), task: {
        title: title,
        description: description,
        status: status,
        user_id: @user.id,
        completed_at: completed_at,
        board_id: @board.id
      }
    end
    get board_path(@board)
    assert_no_match title, response.body
  end
end
