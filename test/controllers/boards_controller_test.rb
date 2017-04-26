require 'test_helper'

class BoardsControllerTest < ActionController::TestCase
  def setup
    @board = boards(:one)
    @admin_user = users(:adminuser)
    @enabled_user = users(:enableduser)
    @disabled_user = users(:disableduser)
    @user_with_no_boards = users(:userwithnoboards)
    @other_user = users(:otheruser)
  end

  test 'should get user index when logged in' do
    sign_in @enabled_user
    get :index
    assert_response :success
    assert_equal assigns(:boards), @enabled_user.boards
  end

  test 'should get admin index when logged in' do
    sign_in @admin_user
    get :index
    assert_response :success
    assert_equal assigns(:boards), Board.all
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should get new when enabled user' do
    sign_in @enabled_user
    get :new
    assert_response :success
  end

  test 'should not get new when disabled user' do
    sign_in @disabled_user
    get :new
    assert_redirected_to boards_path
  end

  test 'should create board when enabled user' do
    sign_in @enabled_user
    assert_difference('Board.count', 1) do
      post :create, board: {
        owner_id: @board.owner_id,
        jira_url: 'test.atlassian.com',
        name: 'new board'
      }
    end

    assert_redirected_to board_path(assigns(:board))
  end

  test 'should redirect create board when disabled user' do
    sign_in @disabled_user
    assert_no_difference('Board.count') do
      post :create, board: { owner_id: @board.owner_id, name: 'new board' }
    end

    assert_redirected_to boards_path
  end

  test 'should redirect create board when not logged in' do
    assert_no_difference('Board.count') do
      post :create, board: { owner_id: @board.owner_id, name: 'new board' }
    end

    assert_redirected_to new_user_session_path
  end

  test 'should show board when logged in as board member' do
    sign_in @enabled_user
    get :show, id: @board.id
    assert_response :success
  end

  test 'should show board when logged in as admin' do
    sign_in @admin_user
    get :show, id: @board.id
    assert_response :success
  end

  test 'should redirect show board when logged in as non-board member' do
    sign_in @user_with_no_boards
    get :show, id: @board.id
    assert_redirected_to boards_path
  end

  test 'should redirect show board when not logged in' do
    get :show, id: @board.id
    assert_redirected_to new_user_session_path
  end

  test 'should get edit when logged in as board owner' do
    sign_in @enabled_user
    get :edit, id: @board.id
    assert_response :success
  end

  test 'should get edit when logged in as admin' do
    sign_in @admin_user
    get :edit, id: @board
    assert_response :success
  end

  test 'should redirect edit when logged in as non owner, non-admin' do
    sign_in @other_user
    get :edit, id: @board
    assert_redirected_to boards_path
  end

  test 'should redirect edit when logged in as non-member' do
    sign_in @user_with_no_boards
    get :edit, id: @board
    assert_redirected_to boards_path
  end

  test 'should redirect edit when not logged in' do
    sign_in @user_with_no_boards
    get :edit, id: @board
    assert_redirected_to boards_path
  end

  test 'should update board when logged in as board owner' do
    sign_in @enabled_user
    patch :update, id: @board, board: {
      owner_id: @board.owner_id,
      name: 'new name'
    }
    assert_equal @board.reload.name, 'new name'
    assert_redirected_to board_path(assigns(:board))
  end

  test 'should update board when logged in as admin' do
    sign_in @admin_user
    patch :update, id: @board, board: {
      owner_id: @board.owner_id,
      name: 'new name'
    }
    assert_equal @board.reload.name, 'new name'
    assert_redirected_to board_path(assigns(:board))
  end

  test 'should redirect update board when logged in as non-owner, non-admin' do
    sign_in @other_user
    patch :update, id: @board, board: {
      owner_id: @board.owner_id,
      name: 'new name'
    }
    assert_not_equal @board.reload.name, 'new name'
    assert_redirected_to boards_path
  end

  test 'should redirect update when logged in as non-member' do
    sign_in @user_with_no_boards
    patch :update, id: @board, board: {
      owner_id: @board.owner_id,
      name: 'new name'
    }
    assert_not_equal @board.reload.name, 'new name'
    assert_redirected_to boards_path
  end

  test 'should redirect update when not logged in' do
    patch :update, id: @board, board: {
      owner_id: @board.owner_id,
      name: 'new name'
    }
    assert_not_equal @board.reload.name, 'new name'
    assert_redirected_to new_user_session_path
  end

  test 'should destroy board when logged in as admin' do
    sign_in @admin_user
    assert_difference('Board.count', -1) do
      delete :destroy, id: @board
    end
    assert_redirected_to boards_path
  end

  test 'should redirect destroy board when logged in as board owner' do
    sign_in @enabled_user
    assert_no_difference('Board.count') do
      delete :destroy, id: @board
    end
    assert_redirected_to boards_path
  end

  test 'should redirect destroy when logged in as non-admin board member' do
    sign_in @other_user
    assert_no_difference('Board.count') do
      delete :destroy, id: @board
    end
    assert_redirected_to boards_path
  end

  test 'should redirect destroy when logged in as non board member' do
    sign_in @user_with_no_boards
    assert_no_difference('Board.count') do
      delete :destroy, id: @board
    end
    assert_redirected_to boards_path
  end
end
