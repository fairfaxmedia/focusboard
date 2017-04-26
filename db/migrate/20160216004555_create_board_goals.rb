class CreateBoardGoals < ActiveRecord::Migration
  def change
    create_table :board_goals do |t|
      t.string :name
      t.references :board, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
