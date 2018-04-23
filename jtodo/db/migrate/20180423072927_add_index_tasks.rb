class AddIndexTasks < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :title
    add_index :tasks, :description, length: 255
    add_index :tasks, :status
  end
end
