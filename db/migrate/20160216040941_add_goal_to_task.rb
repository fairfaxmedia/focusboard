class AddGoalToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :board_goal, index: true
  end
end
