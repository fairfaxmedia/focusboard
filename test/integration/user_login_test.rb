require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:enableduser)
    @unconfirmed_user = users(:unconfirmeduser)
  end

  test 'login with valid information followed by logout' do
    get new_user_session_path
    post user_session_path, user: { email: @user.email, password: 'password' }
    assert_redirected_to root_path
    follow_redirect!
    assert_redirected_to boards_path
    follow_redirect!
    assert_template 'boards/index'
    assert_match 'Signed in successfully', response.body
    assert_not flash.empty?
    delete destroy_user_session_path
    assert_redirected_to root_path
    follow_redirect!
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template 'sessions/new'
  end

  test 'login with invalid information' do
    get new_user_session_path
    post user_session_path, user: { email: @user.email, password: 'fooobarz' }
    assert_not flash.empty?
    assert_match 'Invalid email or password.', response.body
    assert_template 'sessions/new'
  end

  test 'login as unconfirmed user' do
    get new_user_session_path
    post user_session_path, user: {
      email: @unconfirmed_user.email,
      password: 'password'
    }
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template 'sessions/new'
    assert_match(
      'You have to confirm your email address before continuing.',
      response.body
    )
  end
end
