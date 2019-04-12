class AddStatusToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status_id, :integer, limit: 1, :null => false
  end
end
