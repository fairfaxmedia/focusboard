require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get new_user_registration_path
    assert_template 'registrations/new'

    assert_no_difference 'User.count' do
      post user_registration_path, user: {
        name: '',
        email: 'user@invalid',
        password: 'foo',
        password_confirmation: 'bar'
      }
    end

    assert_template 'registrations/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information' do
    get new_user_registration_path
    assert_template 'registrations/new'

    assert_difference 'User.count', 1 do
      post user_registration_path, user: {
        name: 'Cameron',
        email: 'cameron@example.com',
        password: 'foobarfoobar',
        password_confirmation: 'foobarfoobar'
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template 'devise/sessions/new'
  end
end
