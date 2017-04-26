require 'test_helper'

class TaskCreationTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:enableduser)
    @board = boards(:one)
  end

  test 'task interface' do
    # Log in
    post user_session_path, user: { email: @user.email, password: 'password' }

    # Invalid task
    assert_no_difference 'Task.count' do
      post board_tasks_path(@board), task: {
        title: '',
        description: '',
        status: '',
        user_id: @user.id,
        board_id: @board.id
      }
    end

    # Valid task
    title = 'sample text'
    description = 'a sample task'
    status = 'active'
    assert_difference 'Task.count', 1 do
      post board_tasks_path(@board), task: {
        title: title,
        description: description,
        status: status,
        user_id: @user.id,
        board_id: @board.id
      }
    end

    assert_redirected_to @board
    follow_redirect!
    assert_template 'boards/show'
    assert_match title, response.body
    assert_match description, response.body

    task = @user.tasks.first
    # Task editing
    title = 'edited title'
    get edit_task_path(task)
    assert_template 'tasks/edit'
    patch(
      task_path(task),
      { task: { title: title } },
      referer: edit_task_url(task)
    )
    assert_redirected_to task_path(task)
    follow_redirect!
    assert_template 'tasks/show'
    assert_match title, response.body

    # Task deletion
    assert_difference 'Task.count', -1 do
      delete task_path(task)
    end
  end
end
