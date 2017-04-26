class ChangeTaskNoteContentToText < ActiveRecord::Migration
  def up
    change_column :task_notes, :content, :text
  end

  def down
    change_column :task_notes, :content, :string
  end
end
