class AddColourToBoardGoal < ActiveRecord::Migration
  def change
    add_column :board_goals, :colour, :string
  end
end
