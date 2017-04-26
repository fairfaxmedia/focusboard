class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.references :owner, index: true

      t.timestamps null: false
    end
    add_foreign_key :boards, :users, column: :owner_id
  end
end
