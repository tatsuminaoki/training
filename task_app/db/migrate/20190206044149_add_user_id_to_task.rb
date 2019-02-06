class AddUserIdToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :user_id, :integer, after: :id, null: false
    add_index  :tasks, :user_id
  end
end
