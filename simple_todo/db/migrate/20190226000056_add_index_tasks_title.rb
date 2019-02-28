class AddIndexTasksTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :title
    add_index :tasks, :user_id
  end
end
