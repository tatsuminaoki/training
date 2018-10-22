class AddForignUserToTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :user_id, :integer
    add_reference :tasks, :user, foreign_key: true
  end
end
