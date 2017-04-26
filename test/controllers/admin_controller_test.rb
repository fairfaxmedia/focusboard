require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test 'should get index when admin' do
    sign_in users(:adminuser)
    get :index
    assert_response :success
  end

  test 'should redirect index when not admin and enabled' do
    sign_in users(:enableduser)
    get :index
    assert_redirected_to boards_path
  end

  test 'should redirect index when not admin and disabled' do
    sign_in users(:disableduser)
    get :index
    assert_redirected_to boards_path
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_redirected_to new_user_session_path
  end
end
