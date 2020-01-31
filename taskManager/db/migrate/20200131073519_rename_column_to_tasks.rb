class RenameColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :drafter,  :drafter_id
    rename_column :tasks, :reporter, :reporter_id
    rename_column :tasks, :assignee, :assignee_id
  end
end
