class AddTaskStatusToTasks < ActiveRecord::Migration[6.0]
  def up
    add_column :tasks, :status, :integer, null: false, default: 0, after: :description
  end

  def down
    remove_column :tasks, :status, :integer
  end
end
