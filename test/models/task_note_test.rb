require 'test_helper'

class TaskNoteTest < ActiveSupport::TestCase
  def setup
    @user = users(:enableduser)
    @task_note = task_notes(:enabled_user_task_note)
  end

  test 'should be valid' do
    assert @task_note.valid?
  end

  test 'task_id should be present' do
    @task_note.task_id = nil
    assert_not @task_note.valid?
  end

  test 'non-integer task_id should be invalid' do
    @task_note.task_id = 'aaa'
    assert_not @task_note.valid?
  end

  test 'integer task_id should be valid' do
    @task_note.task_id = 1
    assert @task_note.valid?
  end

  test 'content should be present' do
    @task_note.content = nil
    assert_not @task_note.valid?
  end

  test 'content should accept strings of any length' do
    @task_note.content = 'a' * 256
    assert @task_note.valid?
  end

  test 'default scope should be ordered by created_at ascending' do
    assert_equal TaskNote.all.order(created_at: :asc), TaskNote.all
  end
end
