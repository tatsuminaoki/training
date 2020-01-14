class AddIndexToTasks < ActiveRecord::Migration[6.0]
  def up
    add_index :tasks, :status
  end

  def down
    remove_index :tasks, :status
  end
end
