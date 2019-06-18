class RemoveIndexFromTasks < ActiveRecord::Migration[5.2]
  def change
    remove_index :tasks, [:title, :status]
    add_index :tasks, :title
  end
end
