class RenameDiscriptionColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :discription, :description
  end
end
