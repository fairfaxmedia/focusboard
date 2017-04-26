class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.string :status
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
