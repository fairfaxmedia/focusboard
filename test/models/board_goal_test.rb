require 'test_helper'

class BoardGoalTest < ActiveSupport::TestCase
  def setup
    @board_goal = board_goals(:one)
  end

  test 'should be valid' do
    assert @board_goal.valid?
  end

  test 'name <2 chars should be invalid' do
    @board_goal.name = 'a'
    assert_not @board_goal.valid?
  end

  test 'name >100 chars should be invalid' do
    @board_goal.name = 'a' * 101
    assert_not @board_goal.valid?
  end

  test 'board_id should be present' do
    @board_goal.board_id = nil
    assert_not @board_goal.valid?
  end

  test 'name should be unique in board scope' do
    second_goal = board_goals(:two)
    second_goal.board = @board_goal.board
    second_goal.name = @board_goal.name
    assert_not second_goal.valid?
  end
end
