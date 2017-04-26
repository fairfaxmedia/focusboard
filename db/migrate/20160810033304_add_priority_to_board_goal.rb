class AddPriorityToBoardGoal < ActiveRecord::Migration
  def change
    add_column :board_goals, :priority, :integer
  end
end
