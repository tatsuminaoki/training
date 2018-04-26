class AddIndexTasks < ActiveRecord::Migration[5.2]
  def up
    add_index :tasks, :title
    add_index :tasks, :description, length: 255
    add_index :tasks, :status
  end
  def down
    remove_index :tasks, :title
    remove_index :tasks, :description
    remove_index :tasks, :status
  end
end
