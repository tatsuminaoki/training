class AddUserIdToId < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :user_id, :bigint
    add_foreign_key :tasks, :users, column: "user_id"
  end
end
