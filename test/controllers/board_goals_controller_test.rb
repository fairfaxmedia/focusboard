require 'test_helper'

class BoardGoalsControllerTest < ActionController::TestCase
  def setup
    @user = users(:enableduser)
    @board = @user.boards.first
  end

  test 'post#create should create a new goal when logged in as board owner' do
    sign_in @user
    assert_difference('@board.goals.count', 1) do
      post :create, board_id: @board.id, board_goal: {
        board_id: @board.id,
        name: 'test',
        priority: 1
      }
    end
    assert_redirected_to edit_board_path(@board)
  end

  test 'post#create should not create a new goal when logged out' do
    assert_no_difference('@board.goals.count') do
      post :create, board_id: @board.id, board_goal: {
        board_id: @board.id,
        name: 'test',
        priority: 1
      }
    end
    assert_redirected_to new_user_session_path
  end

  test 'post#create shouldnt create new goal when user is non-board owner' do
    sign_in users(:otheruser)
    assert_no_difference('@board.goals.count') do
      post :create, board_id: @board.id, board_goal: {
        board_id: @board.id, name: 'test', priority: 1
      }
    end
    assert_redirected_to boards_path
  end
end
