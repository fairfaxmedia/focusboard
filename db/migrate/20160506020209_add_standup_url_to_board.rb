class AddStandupUrlToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :standup_url, :text
  end
end
