require 'test_helper'

class UserStatusTest < ActiveSupport::TestCase
  def setup
    @user_status = user_statuses(:one)
  end

  test 'should be valid' do
    assert @user_status.valid?
  end

  test 'status should be present' do
    @user_status.status = '    '
    assert_not @user_status.valid?
  end

  test 'default scope should be ordered by created_at ascending' do
    assert_equal UserStatus.all.order(created_at: :asc), UserStatus.all
  end

  test 'created_this_week should return statuses created this week only' do
    UserStatus.created_this_week.find_each do |user_status|
      assert(
        user_status.created_at >= Time.zone.now.beginning_of_week \
          && user_status.created_at <= Time.zone.now.end_of_week
      )
    end
  end

  test 'created_today scope should return DailyNotes created today' do
    UserStatus.created_today.find_each do |user_status|
      assert(
        user_status.created_at >= Date.current.beginning_of_day \
          && user_status.created_at <= Date.current.end_of_day
      )
    end
  end
end
