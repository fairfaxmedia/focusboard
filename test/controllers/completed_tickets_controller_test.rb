require 'test_helper'

class CompletedTicketsControllerTest < ActionController::TestCase
  def setup
    @user = users(:enableduser)
  end

  test 'should post #create when logged in' do
    sign_in @user
    assert_difference('@user.completed_tickets.this_week.count', 1) do
      post :create, user_id: @user.id, completed_ticket: {}
    end
    assert_redirected_to root_path
  end
end
