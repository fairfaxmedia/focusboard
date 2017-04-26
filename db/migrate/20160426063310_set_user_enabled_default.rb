class SetUserEnabledDefault < ActiveRecord::Migration
  def change
    change_column_default(:users, :enabled, true)
  end
end
