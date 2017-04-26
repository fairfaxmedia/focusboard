require 'test_helper'

class UserStatusesControllerTest < ActionController::TestCase
  setup do
    @enabled_user = users(:enableduser)
    @other_user = users(:otheruser)
    @admin_user = users(:adminuser)
    @user_status = user_statuses(:one)
  end

  test 'should create status when logged in as correct user' do
    sign_in @enabled_user
    assert_difference('@enabled_user.statuses.count', 1) do
      post :create, user_status: { status: 'WFH' }, user_id: @enabled_user.id
    end
    assert_redirected_to root_path
  end

  test 'should create status when logged in as admin' do
    sign_in @admin_user
    assert_difference('@enabled_user.statuses.count', 1) do
      post :create, user_status: { status: 'WFH' }, user_id: @enabled_user.id
    end
    assert_redirected_to root_path
  end

  test 'should redirect create when logged in as incorrect user' do
    sign_in @other_user
    assert_no_difference('UserStatus.count') do
      post :create, user_status: { status: 'WFH' }, user_id: @enabled_user.id
    end
    assert_redirected_to boards_path
  end

  test 'should redirect create when not logged in' do
    assert_no_difference('UserStatus.count') do
      post :create, user_status: { status: 'WFH' }, user_id: @enabled_user.id
    end
    assert_redirected_to new_user_session_path
  end

  test 'should delete status when logged in as correct user' do
    sign_in @enabled_user
    assert_difference('@enabled_user.statuses.count', -1) do
      delete :destroy, user_id: @enabled_user.id, id: @user_status.id
    end
    assert_redirected_to root_path
  end

  test 'should delete status when logged in as admin' do
    sign_in @admin_user
    assert_difference('@enabled_user.statuses.count', -1) do
      delete :destroy, user_id: @enabled_user.id, id: @user_status.id
    end
    assert_redirected_to root_path
  end

  test 'should redirect delete when logged in as incorrect user' do
    sign_in @other_user
    assert_no_difference('UserStatus.count') do
      delete :destroy, user_id: @enabled_user.id, id: @user_status.id
    end
    assert_redirected_to boards_path
  end

  test 'should redirect delete when not logged in' do
    assert_no_difference('UserStatus.count') do
      delete :destroy, user_id: @enabled_user.id, id: @user_status.id
    end
    assert_redirected_to new_user_session_path
  end
end
