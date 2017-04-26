require 'test_helper'

class DailyNoteTest < ActiveSupport::TestCase
  def setup
    @user = users(:enableduser)
    @daily_note = daily_notes(:enabled_user_daily_note)
  end

  test 'should be valid' do
    assert @daily_note.valid?
  end

  test 'user_id should be present' do
    @daily_note.user_id = nil
    assert_not @daily_note.valid?
  end

  test 'non-integer user_id should be invalid' do
    @daily_note.user_id = 'aaa'
    assert_not @daily_note.valid?
  end

  test 'integer user_id should be valid' do
    @daily_note.user_id = 1
    assert @daily_note.valid?
  end

  test 'content should accept strings of any length' do
    @daily_note.content = 'a' * 256
    assert @daily_note.valid?
  end

  test 'content should be present' do
    @daily_note.content = nil
    assert_not @daily_note.valid?
  end

  test 'created_today scope should return DailyNotes created today' do
    DailyNote.created_today.find_each do |daily_note|
      assert daily_note.created_at >= Date.current.beginning_of_day \
             && daily_note.created_at <= Date.current.end_of_day
    end
  end

  test 'created_yesterday scope should return DailyNotes created yesterday' do
    DailyNote.created_yesterday.find_each do |daily_note|
      assert daily_note.created_at >= 1.day.ago.to_date.beginning_of_day \
             && daily_note.created_at <= 1.day.ago.to_date.end_of_day
    end
  end

  test 'default scope should be ordered by created_at descending' do
    assert_equal DailyNote.all.order(created_at: :desc), DailyNote.all
  end
end
