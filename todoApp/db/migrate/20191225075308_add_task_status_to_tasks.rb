class AddTaskStatusToTasks < ActiveRecord::Migration[6.0]
  def up
    add_column :tasks, :status, :integer, null: false, default: 0
  end

  def down
    remove_column :tasks, :status, :integer
  end
end
