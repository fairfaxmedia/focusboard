class AddPositiveOutcomeToDailyNotes < ActiveRecord::Migration
  def change
    add_column :daily_notes, :positive_outcome, :boolean
  end
end
