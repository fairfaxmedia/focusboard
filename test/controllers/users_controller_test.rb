require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @admin_user = users(:adminuser)
    @enabled_user = users(:enableduser)
    @disabled_user = users(:disableduser)
  end

  test 'should get index when admin' do
    sign_in @admin_user
    get :index
    assert_response :success
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_redirected_to new_user_session_url
  end

  test 'should redirect index when not admin' do
    sign_in @enabled_user
    get :index
    assert_redirected_to boards_path
  end

  test 'should destroy when admin' do
    sign_in @admin_user
    assert_difference('User.count', -1) do
      delete :destroy, id: @enabled_user
    end
    assert_redirected_to users_url
  end

  test 'should not destroy when not admin' do
    sign_in @enabled_user
    assert_no_difference('User.count') do
      delete :destroy, id: @admin_user
    end
    assert_redirected_to boards_path
  end

  test 'should disable when admin' do
    sign_in @admin_user
    patch :update, id: @enabled_user
    assert_not_equal @enabled_user.enabled, @enabled_user.reload.enabled
    assert :success
  end

  test 'should enable when admin' do
    sign_in @admin_user
    patch :update, id: @disabled_user
    assert_not_equal @disabled_user.enabled, @disabled_user.reload.enabled
    assert :success
  end

  test 'should not update when not admin' do
    sign_in @enabled_user
    patch :update, id: @disabled_user
    assert_equal @enabled_user.enabled, @enabled_user.reload.enabled
    assert_redirected_to boards_path
  end

  test 'should not update when not logged in' do
    patch :update, id: @disabled_user
    assert_equal @enabled_user.enabled, @enabled_user.reload.enabled
    assert_redirected_to new_user_session_url
  end
end
