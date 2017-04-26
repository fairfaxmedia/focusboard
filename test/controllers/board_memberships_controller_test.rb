require 'test_helper'

class BoardMembershipsControllerTest < ActionController::TestCase
  def setup
    @enabled_user = users(:enableduser)
    @admin_user = users(:adminuser)
    @user_with_no_boards = users(:userwithnoboards)
    @other_user = users(:otheruser)
    @board = boards(:one)
  end

  test 'should create when logged in as board owner' do
    sign_in @enabled_user
    assert_difference('@user_with_no_boards.boards.count', 1) do
      post :create,
           board_id: @board.id,
           board_membership: { user_id: @user_with_no_boards.id }
    end
    assert_redirected_to edit_board_path(@board)
  end

  test 'should create when logged in as admin' do
    sign_in @admin_user
    assert_difference('@user_with_no_boards.boards.count', 1) do
      post :create,
           board_id: @board.id,
           board_membership: { user_id: @user_with_no_boards.id }
    end
    assert_redirected_to edit_board_path(@board)
  end

  test 'should redirect create when logged in as non-admin, non-owner member' do
    sign_in @other_user
    assert_no_difference('@user_with_no_boards.boards.count') do
      post :create,
           board_id: @board.id,
           board_membership: { user_id: @user_with_no_boards.id }
    end
    assert_redirected_to boards_path
  end

  test 'should redirect create when logged in as non-member' do
    sign_in @user_with_no_boards
    assert_no_difference('@user_with_no_boards.boards.count') do
      post :create,
           board_id: @board.id,
           board_membership: { user_id: @user_with_no_boards.id }
    end
    assert_redirected_to boards_path
  end

  test 'should redirect create when not logged in' do
    assert_no_difference('@user_with_no_boards.boards.count') do
      post :create,
           board_id: @board.id,
           board_membership: { user_id: @user_with_no_boards.id }
    end
    assert_redirected_to new_user_session_path
  end


  test 'should delete when logged in as board owner' do
    owner = @board.owner
    sign_in owner
    membership = @board.board_memberships.where.not(user_id: @owner).first
    assert_difference('@board.users.count', -1) do
      delete :destroy, id: membership.id
    end
    assert_redirected_to edit_board_path(@board)
  end

  test 'should delete when logged in as admin' do
    sign_in @admin_user
    membership = @other_user.board_memberships.first
    assert_difference('@board.users.count', -1) do
      delete :destroy, id: membership.id
    end
    assert_redirected_to edit_board_path(@board)
  end

  test 'should delete when logged in as same user' do
    sign_in @other_user
    membership = @other_user.board_memberships.first
    assert_difference('@board.users.count', -1) do
      delete :destroy, id: membership.id
    end
    assert_redirected_to boards_path
  end

  test 'should not delete board owner' do
    sign_in @admin_user
    membership = @enabled_user.board_memberships.first
    assert_no_difference('@board.users.count') do
      delete :destroy, id: membership.id
    end
    assert_redirected_to edit_board_path(@board)
  end

  test 'should redirect delete when logged in as non-admin, non-owner member' do
    sign_in @other_user
    membership = @admin_user.board_memberships.first
    assert_no_difference('@board.users.count') do
      delete :destroy, id: membership.id
    end
    assert_redirected_to boards_path
  end

  test 'should redirect delete when logged in as non-member' do
    sign_in @user_with_no_boards
    membership = @other_user.board_memberships.first
    assert_no_difference('@board.users.count') do
      delete :destroy, id: membership.id
    end
    assert_redirected_to boards_path
  end

  test 'should redirect delete when not logged in' do
    membership = @other_user.board_memberships.first
    assert_no_difference('@board.users.count') do
      delete :destroy, id: membership.id
    end
    assert_redirected_to new_user_session_path
  end
end
