class AddJiraToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :jira, :string
  end
end
