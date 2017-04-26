class CreateTaskStatuses < ActiveRecord::Migration
  def change
    create_table :task_statuses do |t|
      t.string :status
      t.references :task, index: true, foreign_key: true
      t.timestamp :finished_at

      t.timestamps null: false
    end
  end
end
