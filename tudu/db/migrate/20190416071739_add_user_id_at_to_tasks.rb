class AddUserIdAtToTasks < ActiveRecord::Migration[5.2]
  def up
    add_column :tasks, :user_id, :bigint, null: false, after: :id
    add_foreign_key :tasks, :users, column: :user_id
  end

  def down
    remove_column :tasks, :user_id, :bigint
  end
end
