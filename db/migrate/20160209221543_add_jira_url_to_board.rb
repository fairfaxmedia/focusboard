class AddJiraUrlToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :jira_url, :string
  end
end
