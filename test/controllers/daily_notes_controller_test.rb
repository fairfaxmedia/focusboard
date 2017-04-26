require 'test_helper'

class DailyNotesControllerTest < ActionController::TestCase
  setup do
    @enabled_user_daily_note = daily_notes(:enabled_user_daily_note)
    @admin_daily_note = daily_notes(:admin_daily_note)
    @disabled_user_daily_note = daily_notes(:disabled_user_daily_note)
    @enabled_user = users(:enableduser)
    @disabled_user = users(:disableduser)
    @admin_user = users(:adminuser)
    @other_user = users(:otheruser)
  end

  test 'should get user index when logged in' do
    sign_in @enabled_user
    get :index, user_id: @enabled_user.id
    assert_response :success
    assert_not_nil assigns(:daily_notes)
    assert_equal(
      assigns(:daily_notes),
      @enabled_user.daily_notes.order(created_at: :desc)
    )
  end

  test 'should get admin index when logged in' do
    sign_in @admin_user
    get :index, user_id: @enabled_user.id
    assert_response :success
    assert_not_nil assigns(:daily_notes)
    assert_equal(
      assigns(:daily_notes),
      @enabled_user.daily_notes.order(created_at: :desc)
    )
  end

  test 'should redirect index when not logged in' do
    get :index, user_id: @enabled_user.id
    assert_redirected_to new_user_session_path
    assert_not flash.empty?
  end

  test 'should redirect index when disabled user' do
    sign_in @disabled_user
    get :index, user_id: @disabled_user.id
    assert_redirected_to boards_path
  end

  test 'should get boards/:board_id/daily_notes when board owner' do
    sign_in @enabled_user
    board = boards(:one)
    get :index, board_id: board.id
    assert_equal assigns(:daily_notes),
                 DailyNote.where(user_id: board.users.map(&:id)).page(1)
  end

  test 'should redirect boards/:board_id/daily_notes when not board owner' do
    sign_in @other_user
    get :index, board_id: boards(:one).id
    assert_redirected_to boards_path
  end

  test 'should get new when logged in as enabled user' do
    sign_in @enabled_user
    get :new, user_id: @enabled_user.id
    assert_response :success
  end

  test 'should redirect new when logged in as disabled user' do
    sign_in @disabled_user
    get :new, user_id: @disabled_user.id
    assert_redirected_to boards_path
  end

  test 'should redirect new when not logged in' do
    get :new, user_id: @enabled_user.id
    assert_redirected_to new_user_session_path
  end

  test 'should create daily_note when logged in as enabled user' do
    sign_in @enabled_user
    assert_difference('DailyNote.count') do
      post :create, user_id: @enabled_user, daily_note: {
        content: @enabled_user_daily_note.content
      }
    end

    assert_redirected_to daily_note_path(assigns(:daily_note))
  end

  test 'should redirect create when logged in as disabled user' do
    sign_in @disabled_user
    assert_no_difference('DailyNote.count') do
      post :create, user_id: @disabled_user, daily_note: {
        content: @enabled_user_daily_note.content
      }
    end

    assert_redirected_to boards_path
  end

  test 'should redirect create when not logged in' do
    assert_no_difference('DailyNote.count') do
      post :create, user_id: @enabled_user, daily_note: {
        content: @enabled_user_daily_note.content
      }
    end

    assert_redirected_to new_user_session_path
  end

  test 'should show daily_note when logged in as correct user' do
    sign_in @enabled_user
    get :show, id: @enabled_user_daily_note.id
    assert_response :success
  end

  test 'should show daily_note when logged in as admin' do
    sign_in @admin_user
    get :show, id: @enabled_user_daily_note.id
    assert_response :success
  end

  test 'should redirect show when not logged in' do
    get :show, id: @enabled_user_daily_note.id
    assert_redirected_to new_user_session_path
  end

  test 'should redirect show when disabled user' do
    sign_in @disabled_user
    get :show, id: @enabled_user_daily_note.id
    assert_redirected_to boards_path
  end

  test 'should redirect show when incorrect user' do
    sign_in @other_user
    get :show, id: @admin_daily_note.id
    assert_redirected_to boards_path
  end

  test 'should get edit when logged in as correct user' do
    sign_in @enabled_user
    get :edit, id: @enabled_user_daily_note
    assert_response :success
  end

  test 'should redirect edit when disabled user' do
    sign_in @disabled_user
    get :edit, id: @disabled_user_daily_note
    assert_redirected_to boards_path
  end

  test 'should redirect edit when incorrect user' do
    sign_in @other_user
    get :edit, id: @admin_daily_note
    assert_redirected_to boards_path
  end

  test 'should redirect edit when not logged in' do
    get :edit, id: @enabled_user_daily_note
    assert_redirected_to new_user_session_path
  end

  test 'should update daily_note when logged in as correct user' do
    sign_in @enabled_user
    patch :update, id: @enabled_user_daily_note, daily_note: {
      content: 'new content',
      user_id: @enabled_user_daily_note.user_id
    }
    assert_equal(
      'new content',
      DailyNote.find(@enabled_user_daily_note.id).content
    )
    assert_redirected_to daily_note_path(assigns(:daily_note))
  end

  test 'should redirect update logged in as incorrect user' do
    sign_in @other_user
    patch :update, id: @admin_daily_note, daily_note: {
      content: 'new content',
      user_id: @admin_daily_note.user_id
    }
    assert_not_equal 'new content', DailyNote.find(@admin_daily_note.id).content
    assert_redirected_to boards_path
  end

  test 'should redirect update logged in as disabled user' do
    sign_in @disabled_user
    patch :update, id: @disabled_user_daily_note, daily_note: {
      content: 'new content',
      user_id: @disabled_user_daily_note.user_id
    }
    assert_not_equal(
      'new content',
      DailyNote.find(@disabled_user_daily_note.id).content
    )
    assert_redirected_to boards_path
  end

  test 'should redirect update when not logged in' do
    patch :update, id: @enabled_user_daily_note, daily_note: {
      content: @enabled_user_daily_note.content,
      user_id: @enabled_user_daily_note.user_id
    }
    assert_redirected_to new_user_session_path
  end

  test 'should destroy daily_note when logged in as correct user' do
    sign_in @enabled_user
    assert_difference('DailyNote.count', -1) do
      delete :destroy, id: @enabled_user_daily_note
    end

    assert_redirected_to user_daily_notes_path(@enabled_user)
  end

  test 'should redirect destroy when logged in as incorrect user' do
    sign_in @enabled_user
    assert_no_difference('DailyNote.count') do
      delete :destroy, id: @admin_daily_note
    end

    assert_redirected_to boards_path
  end

  test 'should redirect destroy when logged in as disabled' do
    sign_in @disabled_user
    assert_no_difference('DailyNote.count') do
      delete :destroy, id: @disabled_user_daily_note
    end

    assert_redirected_to boards_path
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference('DailyNote.count') do
      delete :destroy, id: @enabled_user_daily_note
    end

    assert_redirected_to new_user_session_path
  end
end
