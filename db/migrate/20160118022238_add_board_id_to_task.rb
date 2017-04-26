class AddBoardIdToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :board, index: true
  end
end
