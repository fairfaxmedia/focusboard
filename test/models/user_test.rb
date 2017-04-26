require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:enableduser)
    @other_user = users(:otheruser)
    @board = boards(:one)
    @task = tasks(:two)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '        '
    assert_not @user.valid?
  end

  test 'name <2 chars should be invalid' do
    @user.name = 'a'
    assert @user.invalid?
  end

  test '1< name <=50 chars should be valid' do
    @user.name = 'a' * 50
    assert @user.valid?
  end

  test 'name >50 chars should be invalid' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'non-boolean admin should be invalid' do
    @user.admin = nil
    assert_not @user.valid?
  end

  test 'boolean admin should be valid' do
    @user.admin = true
    assert @user.valid?
    @user.admin = false
    assert @user.valid?
  end

  test 'non-boolean enabled should be invalid' do
    @user.enabled = nil
    assert_not @user.valid?
  end

  test 'boolean enabled should be valid' do
    @user.enabled = true
    assert @user.valid?
    @user.enabled = false
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = '      '
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(
      user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn
    )
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, '#{valid_address.inspect} should be valid'
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w(
      user@example,com user_at_foo.org user.name@example. xyz
    )
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, '#{invalid_address.inspect} should be invalid'
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'associated tasks should be destroyed' do
    assert_difference 'Task.count', -(@other_user.tasks.count) do
      @other_user.destroy
    end
  end

  test 'tasks_active_today should return correct results' do
    @user.tasks_active_today(@board).find_all do |task|
      assert task.active? || task.completed_at >= Time.current.beginning_of_day
    end
  end

  test 'reviewed_today? should return correct results' do
    daily_notes = @user.daily_notes.where(
      'created_at >= ?', Time.current.beginning_of_day
    )
    if daily_notes.any?
      assert @user.reviewed_today?
    else
      assert_not @user.reviewed_today?
    end
  end

  test 'todays_review should return review created today' do
    review = @user.daily_notes.new(content: 'hello world')
    review.save
    assert_equal @user.todays_review, review
  end

  test 'todays_review should not return review created yesterday' do
    review = daily_notes(:enabled_user_daily_note)
    review.created_at = 1.day.ago
    review.save
    review.reload
    assert_not_equal @user.todays_review, review
    assert_nil @user.todays_review
  end

  test 'name_and_email should return correct name and email' do
    assert_equal @user.name_and_email, "#{@user.name} (#{@user.email})"
  end

  test 'tasks_created_this_week should return correct tasks' do
    @user.tasks_created_this_week(@board).find_all do |task|
      assert task.created_at >= Time.zone.now.beginning_of_week
    end
  end

  test 'tasks_created_and_completed_this_week should return correct tasks' do
    @user.tasks_created_and_completed_this_week(@board).find_all do |task|
      assert(
        task.created_at >= Time.zone.now.beginning_of_week && task.completed?
      )
    end
  end

  test 'tasks_completed_this_week should return correct tasks' do
    @user.tasks_completed_this_week(@board).find_all do |task|
      assert task.completed_at >= Time.zone.now.beginning_of_week
    end
  end

  test 'tasks_created_today should return correct tasks' do
    @user.tasks_created_today(@board).find_all do |task|
      assert task.created_at >= Time.zone.now.beginning_of_day
    end
  end

  test 'tasks_created_and_completed_today should return correct tasks' do
    @user.tasks_created_and_completed_today(@board).find_all do |task|
      assert(
        task.created_at >= Time.zone.now.beginning_of_day && task.completed?
      )
    end
  end

  test 'tasks_completed_today should return correct tasks' do
    @user.tasks_completed_today(@board).find_all do |task|
      assert task.completed_at >= Time.zone.now.beginning_of_day
    end
  end

  test 'total_completion_fraction should return correct result' do
    fraction = @user.total_completion_fraction
    assert_equal(
      fraction,
      "#{@user.tasks.completed.length}/#{@user.tasks.length}"
    )
  end

  test 'weekly_completion_fraction should return correct result' do
    fraction = @user.weekly_completion_fraction
    assert_equal(
      fraction,
      "#{@user.tasks_created_and_completed_this_week.length}/" \
      "#{@user.tasks_created_this_week.length}"
    )
  end

  test 'daily_completion_percentage should return correct result' do
    fraction = @user.daily_completion_percentage(@board)
    assert_not_equal fraction, 'NaN'
    assert fraction <= 1 && fraction >= 0
  end

  test 'daily_completion_fraction should return correct result' do
    fraction = @user.daily_completion_fraction(@board)
    assert_equal(
      fraction,
      "#{@user.tasks_completed_today(@board).length}/" \
      "#{@user.tasks_active_today(@board).length}"
    )
  end

  test 'incomplete_tasks should return only incomplete tasks' do
    @user.tasks.incomplete.find_all do |task|
      assert_not_equal task.status, 'completed'
    end
  end

  test 'completed_tasks should return only completed tasks' do
    @user.tasks.completed.find_all do |task|
      assert_equal task.status, 'completed'
    end
  end

  test 'is_member_of? should return correct result' do
    @user.boards.find_all do |board|
      assert @user.member_of?(board)
    end
  end

  test 'on_leave? returns true for user with leave status' do
    user = users(:otheruser)
    assert user.statuses.where(status: 'Leave').any?
    assert user.on_leave?
  end

  test 'on_leave? returns false for user without leave status' do
    user = users(:enableduser)
    assert_not user.statuses.where(status: 'Leave').any?
    assert_not user.on_leave?
  end

  test 'not_member_of scope should only return users not belonging to board' do
    User.not_member_of_board(@board).find_each do |user|
      assert_not user.member_of?(@board)
    end
  end

  test 'without_user should only return users that are not the passed user' do
    User.without_user(@user).find_each { |user| assert_not_equal @user, user }
  end

  test 'ticket_tally should return the number of user tickets this week' do
    assert_equal @user.completed_tickets.this_week.count, @user.ticket_tally
  end
end
