require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  def setup
    @board = boards(:one)
  end

  test 'name should be present' do
    @board.name = '     '
    assert_not @board.valid?
  end

  test 'names > 50 chars should be invalid' do
    @board.name = 'a' * 51
    assert_not @board.valid?
  end

  test 'names <= 50 chars should be invalid' do
    @board.name = 'a' * 50
    assert @board.valid?
  end

  test 'jira_url should allow blank value' do
    @board.jira_url = ''
    assert @board.valid?
  end

  test 'owner_id should be present' do
    @board.owner_id = nil
    assert_not @board.valid?
  end

  test 'non-integer owner_id should be invalid' do
    @board.owner_id = 'aaa'
    assert_not @board.valid?
  end

  test 'integer owner_id should be valid' do
    @board.owner_id = 1
    assert @board.valid?
  end

  test 'membership_for(user) should return membership record for user' do
    user = users(:enableduser)
    membership = BoardMembership.find_by(user_id: user.id, board_id: @board.id)
    assert_equal @board.membership_for(user), membership
  end

  test 'categorise_tasks_by should correctly categorise tasks' do
    tasks = @board.categorise_tasks_by('status')
    tasks.each do |status, task_array|
      task_array.each { |task| assert_equal status, task.status }
    end
  end

  test 'categorise_tasks_by returns the number of tasks for each category' do
    tasks = @board.categorise_tasks_by('status')
    tasks.each do |status, task_array|
      assert_equal @board.tasks.where(status: status).count, task_array.length
    end
  end

  test 'categorise_tasks_by should return a hash of arrays' do
    tasks = @board.categorise_tasks_by('status')
    assert tasks.is_a? Hash
    tasks.each do |_status, task_array|
      assert task_array.is_a? Array
    end
  end

  test 'owned_by? should return true for owner' do
    user = @board.owner
    assert(@board.owned_by?(user))
  end

  test 'owned_by? should return false for non-owner' do
    user = users(:otheruser)
    assert_not(@board.owned_by?(user))
  end
end
