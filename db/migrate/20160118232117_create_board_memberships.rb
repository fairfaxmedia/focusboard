class CreateBoardMemberships < ActiveRecord::Migration
  def change
    drop_table :boards_users
    create_table :board_memberships do |t|
      t.references :user, index: true, foreign_key: true
      t.references :board, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
