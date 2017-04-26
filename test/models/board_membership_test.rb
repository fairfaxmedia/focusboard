require 'test_helper'

class BoardMembershipTest < ActiveSupport::TestCase
  def setup
    @board_membership = board_memberships(:one)
  end

  test 'user_id should be present' do
    @board_membership.user_id = '     '
    assert_not @board_membership.valid?
  end

  test 'non-integer user_id should be invalid' do
    @board_membership.user_id = 'aaa'
    assert_not @board_membership.valid?
  end

  test 'integer user_id should be valid' do
    @board_membership.user_id = 1
    assert @board_membership.valid?
  end

  test 'non-integer board_id should be invalid' do
    @board_membership.board_id = 'aaa'
    assert_not @board_membership.valid?
  end

  test 'integer board_id should be valid' do
    @board_membership.board_id = 1
    assert @board_membership.valid?
  end

  test 'board_id should be present' do
    @board_membership.board_id = '     '
    assert_not @board_membership.valid?
  end
end
