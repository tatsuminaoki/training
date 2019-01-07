class AddIndexesToTasks < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :name
    add_index :tasks, :user_id
  end
end
