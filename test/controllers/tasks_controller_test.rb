require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:two)
    @board = boards(:one)
    @admin_user = users(:adminuser)
    @enabled_user = users(:enableduser)
    @disabled_user = users(:disableduser)
    @other_user = users(:otheruser)
    @request.env['HTTP_REFERER'] = root_url
  end

  test 'should get specified users index when user_id is passed' do
    sign_in @enabled_user
    get :index, user_id: @enabled_user.id
    assert_response :success
    assert_equal assigns(:tasks), @enabled_user.tasks.page(1)
  end

  test 'should get new when logged in' do
    sign_in @enabled_user
    get 'new', board_id: @board.id
    assert_response :success
  end

  test 'should redirect new when not logged in' do
    get :new, board_id: @board.id
    assert_redirected_to new_user_session_url
  end

  test 'should create task for self when logged in' do
    sign_in @enabled_user
    assert_difference('Task.count', 1) do
      post :create, board_id: @board.id, task: {
        status: @task.status,
        title: @task.title,
        user_id: @task.user_id,
        board_id: @board.id
      }
    end
    assert_redirected_to assigns(:task).board
  end

  test 'should not create task for others when logged in as non owner' do
    sign_in @other_user
    assert_no_difference('Task.count') do
      post :create, board_id: @board.id, task: {
        status: @task.status,
        title: @task.title,
        user_id: @enabled_user.id,
        board_id: @board.id
      }
    end
    assert_redirected_to boards_path
  end

  test 'should create task for others when logged in as owner' do
    sign_in @enabled_user
    assert_difference('Task.count', 1) do
      post :create, board_id: @board.id, task: {
        status: @task.status,
        title: @task.title,
        user_id: @other_user.id,
        board_id: @board.id
      }
    end
    assert_redirected_to assigns(:task).board
  end

  test 'should create task for others when logged in as admin' do
    sign_in @admin_user
    assert_difference('Task.count', 1) do
      post :create, board_id: @board.id, task: {
        status: @task.status,
        title: @task.title,
        user_id: @other_user.id,
        board_id: @board.id
      }
    end
    assert_redirected_to assigns(:task).board
  end

  test 'should not create task when not logged in' do
    assert_no_difference('Task.count') do
      post :create, board_id: @board.id, task: {
        description: @task.description,
        status: @task.status,
        title: @task.title,
        user_id: @task.user_id,
        board_id: @board.id
      }
    end
    assert_redirected_to new_user_session_url
  end

  test 'should show task when logged in' do
    sign_in @enabled_user
    get :show, id: @task
    assert_response :success
  end

  test 'should redirect show task when not logged in' do
    get :show, id: @task
    assert_redirected_to new_user_session_url
  end

  test 'should get edit when logged in as correct user' do
    sign_in @enabled_user
    get :edit, id: @task
    assert_response :success
  end

  test 'should get edit when logged in as admin' do
    sign_in @admin_user
    get :edit, id: @task
    assert_response :success
  end

  test 'should redirect edit when logged in as incorrect user' do
    sign_in @other_user
    get :edit, id: @task
    assert_redirected_to boards_path
  end

  test 'should redirect edit when not logged in' do
    get :edit, id: @task
    assert_redirected_to new_user_session_url
  end

  test 'should update task when logged in as correct user' do
    sign_in @enabled_user
    @request.env['HTTP_REFERER'] = task_url(@task)
    patch :update, id: @task, task: {
      status: 'active',
      title: @task.title,
      user_id: @task.user_id,
      board_id: @board.id
    }
    assert_equal 'active', @task.reload.status
    assert_nil @task.completed_at
    assert_redirected_to task_path(assigns(:task))
  end

  test 'should update task when logged in as admin' do
    sign_in @admin_user
    @request.env['HTTP_REFERER'] = task_url(@task)
    patch :update, id: @task, task: {
      status: 'active',
      title: @task.title,
      user_id: @task.user_id,
      board_id: @board.id
    }
    assert_equal 'active', @task.reload.status
    assert_redirected_to task_path(assigns(:task))
  end

  test 'should update completed_at when task set to completed' do
    sign_in @enabled_user
    patch :update, id: @task, task: { status: 'active' }
    assert_nil @task.reload.completed_at
    patch :update, id: @task, task: { status: 'completed' }
    assert_equal @task.reload.status, 'completed'
    assert_not_nil @task.completed_at
    assert_redirected_to root_path
  end

  test 'should not update task logged in as incorrect user' do
    sign_in @disabled_user
    patch :update, id: @task, task: {
      status: 'active',
      title: @task.title,
      user_id: @task.user_id,
      board_id: @board.id
    }
    assert_not_equal 'active', @task.reload.status
    assert_redirected_to boards_path
  end

  test 'should not update task when not logged in' do
    patch :update, id: @task, task: {
      status: 'active',
      title: @task.title,
      user_id: @task.user_id,
      board_id: @board.id
    }
    assert_not_equal 'active', @task.reload.status
    assert_redirected_to new_user_session_path
  end

  test 'should destroy task when admin' do
    sign_in @admin_user
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end
    assert_redirected_to root_path
  end

  test 'should not destroy task when not admin or owner' do
    sign_in @other_user
    assert_no_difference('Task.count') do
      delete :destroy, id: @task
    end
    assert_redirected_to boards_path
  end

  test 'should not destroy task when not logged in' do
    assert_no_difference('Task.count') do
      delete :destroy, id: @task
    end
    assert_redirected_to new_user_session_url
  end
end
