require 'test_helper'

class TaskNotesControllerTest < ActionController::TestCase
  setup do
    @admin_task_note = task_notes(:admin_task_note)
    @user_task_note = task_notes(:enabled_user_task_note)
    @enabled_user = users(:enableduser)
    @disabled_user = users(:disableduser)
    @other_user = users(:otheruser)
  end

  test 'should create task_note when correct user' do
    sign_in @enabled_user
    task = @enabled_user.tasks.first
    assert_difference('TaskNote.count') do
      post :create, task_id: task.id, task_note: {
        content: @user_task_note.content
      }
    end

    assert_redirected_to task_path(@enabled_user.tasks.first.id)
  end

  test 'should redirect create task_note when incorrect user' do
    sign_in @other_user
    task = @enabled_user.tasks.first
    assert_no_difference('TaskNote.count') do
      post :create, task_id: task.id, task_note: {
        content: @user_task_note.content
      }
    end

    assert_redirected_to boards_path
  end

  test 'should redirect create task_note when disabled user' do
    sign_in @disabled_user
    task = @disabled_user.tasks.first
    assert_no_difference('TaskNote.count') do
      post :create, task_id: task.id, task_note: {
        content: @user_task_note.content
      }
    end

    assert_redirected_to boards_path
  end

  test 'should redirect create task_note when not logged in' do
    assert_no_difference('TaskNote.count') do
      post :create, task_id: Task.first.id, task_note: {
        content: @user_task_note.content
      }
    end

    assert_redirected_to new_user_session_path
  end

  test 'should destroy task_note when correct user' do
    sign_in @enabled_user
    task = @user_task_note.task
    assert_difference('TaskNote.count', -1) do
      delete :destroy, id: @user_task_note
    end

    assert_redirected_to task_path(task)
  end

  test 'should redirect destroy when incorrect user' do
    sign_in @other_user
    assert_no_difference('TaskNote.count') do
      delete :destroy, id: @admin_task_note
    end
    assert_redirected_to boards_path
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference('TaskNote.count') do
      delete :destroy, id: @admin_task_note
    end
    assert_redirected_to new_user_session_path
  end
end
